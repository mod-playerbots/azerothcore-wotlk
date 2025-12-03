#!/bin/bash
################################################################################
# AzerothCore Automated Update Script (Testing Environment)
#
# Description: Updates AzerothCore Testing core and modules, rebuilds Docker containers
#
# Usage:
#   ./testing-update-azerothcore.sh              # Update + Rebuild (default)
#   ./testing-update-azerothcore.sh --git-only   # Git updates only, skip rebuild
#   ./testing-update-azerothcore.sh --dry-run    # Show what would be updated
#   ./testing-update-azerothcore.sh --help       # Show this help
#
# Author: OpenCode AI Assistant
# Date: 2025-12-03
# Version: 1.0.1 (Testing-Playerbot)
################################################################################

set -euo pipefail # Exit on error, undefined vars, pipe failures

################################################################################
# CONFIGURATION
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="$HOME/logs/testing"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${LOGS_DIR}/update_${TIMESTAMP}.log"
BUILD_LOG_FILE="${LOGS_DIR}/build_${TIMESTAMP}.log"
START_TIME=$(date +%s)
BUILD_TIMEOUT=3600 # 60 minutes in seconds

# Parse command line arguments
GIT_ONLY=false
DRY_RUN=false

################################################################################
# COLORS & FORMATTING
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

################################################################################
# LOGGING FUNCTIONS
################################################################################

log() {
  local level="$1"
  shift
  local message="$*"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[${timestamp}] [${level}] ${message}" | tee -a "${LOG_FILE}"
}

log_info() {
  echo -e "${CYAN}[INFO]${NC} $*" | tee -a "${LOG_FILE}"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "${LOG_FILE}"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "${LOG_FILE}"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $*" | tee -a "${LOG_FILE}"
}

log_header() {
  echo -e "\n${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}" | tee -a "${LOG_FILE}"
  echo -e "${BOLD}${BLUE} $*${NC}" | tee -a "${LOG_FILE}"
  echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}\n" | tee -a "${LOG_FILE}"
}

################################################################################
# UTILITY FUNCTIONS
################################################################################

get_duration() {
  local end_time=$(date +%s)
  local duration=$((end_time - START_TIME))
  local minutes=$((duration / 60))
  local seconds=$((duration % 60))
  echo "${minutes}m ${seconds}s"
}

cleanup_old_logs() {
  log_info "Cleaning up logs older than 90 days..."
  find "${LOGS_DIR}" -name "*.log" -type f -mtime +90 -delete 2>/dev/null || true
  local deleted_count=$(find "${LOGS_DIR}" -name "*.log" -type f -mtime +90 | wc -l)
  log_info "Cleaned up old logs (found ${deleted_count} files to delete)"
}

show_help() {
  cat <<EOF

${BOLD}AzerothCore Automated Update Script (Testing Environment)${NC}

${BOLD}USAGE:${NC}
    $0 [OPTIONS]

${BOLD}OPTIONS:${NC}
    --git-only      Update Git repositories only, skip Docker rebuild
    --dry-run       Show what would be updated without making changes
    --help          Show this help message

${BOLD}EXAMPLES:${NC}
    $0                      # Update everything and rebuild (default)
    $0 --git-only          # Update Git only, no rebuild
    $0 --dry-run           # Preview updates

${BOLD}BRANCH:${NC}
    Testing-Playerbot (Testing Environment)

${BOLD}LOGS:${NC}
    Location: ${LOGS_DIR}
    Retention: 90 days

EOF
  exit 0
}

################################################################################
# VALIDATION FUNCTIONS
################################################################################

validate_environment() {
  log_header "Pre-flight Checks (Testing Environment)"

  # Check if we're in the correct directory
  if [[ ! -f "${SCRIPT_DIR}/.git/config" ]]; then
    log_error "Not in a git repository. Please run from testing-azerothcore-wotlk directory"
    return 1
  fi

  # Check for git
  if ! command -v git &>/dev/null; then
    log_error "git is not installed"
    return 1
  fi
  log_success "git found: $(git --version)"

  # Check for docker (only if not git-only mode)
  if [[ "${GIT_ONLY}" == "false" ]]; then
    if ! command -v docker &>/dev/null; then
      log_error "docker is not installed"
      return 1
    fi
    log_success "docker found: $(docker --version)"

    if ! docker compose version &>/dev/null; then
      log_error "docker compose is not available"
      return 1
    fi
    log_success "docker compose found: $(docker compose version)"
  fi

  # Check network connectivity
  if ! curl -fsS --max-time 5 https://github.com &>/dev/null; then
    log_error "No network connectivity to GitHub"
    return 1
  fi
  log_success "Network connectivity confirmed"

  # Check for local changes (excluding submodule pointer updates)
  log_info "Checking for local changes..."
  # Get status excluding submodule changes (modules/* directory)
  LOCAL_CHANGES=$(git status --porcelain | grep -v "^.[M] modules/")
  if [[ -n "$LOCAL_CHANGES" ]]; then
    log_error "Local changes detected. Commit or stash changes before updating."
    log_error "Changed files:"
    echo "$LOCAL_CHANGES" | while read line; do
      log_error "  $line"
    done
    exit 1
  fi
  # Log submodule changes if any (informational only)
  SUBMODULE_CHANGES=$(git status --porcelain | grep "^.[M] modules/")
  if [[ -n "$SUBMODULE_CHANGES" ]]; then
    log_info "Submodule pointer updates detected (normal, will be updated):"
    echo "$SUBMODULE_CHANGES" | while read line; do
      log_info "  $line"
    done
  fi

  log_success "No local changes detected"

  log_success "All pre-flight checks passed"
  return 0
}

################################################################################
# VERSION TRACKING
################################################################################

declare -A BEFORE_VERSIONS
declare -A AFTER_VERSIONS
declare -a UPDATED_REPOS

capture_versions() {
  local prefix="$1"

  log_info "Capturing current versions..."

  # Capture core version
  local core_version=$(git rev-parse --short HEAD)
  if [[ "${prefix}" == "before" ]]; then
    BEFORE_VERSIONS["core"]=${core_version}
  else
    AFTER_VERSIONS["core"]=${core_version}
  fi
  log_info "Core: ${core_version}"

  # Capture module versions
  cd "${SCRIPT_DIR}/modules" || return 1
  for module in mod-*; do
    if [[ -d "${module}/.git" ]]; then
      cd "${module}" || continue
      local module_version=$(git rev-parse --short HEAD)
      if [[ "${prefix}" == "before" ]]; then
        BEFORE_VERSIONS["${module}"]=${module_version}
      else
        AFTER_VERSIONS["${module}"]=${module_version}
      fi
      log_info "${module}: ${module_version}"
      cd ..
    fi
  done
  cd "${SCRIPT_DIR}" || return 1
}

generate_change_report() {
  log_header "Update Summary"

  UPDATED_REPOS=()
  local has_updates=false

  # Check core
  if [[ "${BEFORE_VERSIONS[core]:-}" != "${AFTER_VERSIONS[core]:-}" ]]; then
    log_success "Core: ${BEFORE_VERSIONS[core]} → ${AFTER_VERSIONS[core]}"
    UPDATED_REPOS+=("core")
    has_updates=true
  else
    log_info "Core: No changes (${BEFORE_VERSIONS[core]})"
  fi

  # Check modules
  for module in "${!BEFORE_VERSIONS[@]}"; do
    if [[ "${module}" == "core" ]]; then
      continue
    fi

    if [[ "${BEFORE_VERSIONS[${module}]:-}" != "${AFTER_VERSIONS[${module}]:-}" ]]; then
      log_success "${module}: ${BEFORE_VERSIONS[${module}]} → ${AFTER_VERSIONS[${module}]}"
      UPDATED_REPOS+=("${module}")
      has_updates=true
    else
      log_info "${module}: No changes (${BEFORE_VERSIONS[${module}]})"
    fi
  done

  if [[ "${has_updates}" == "false" ]]; then
    log_info "No updates available - all repositories are up to date"
    return 1 # Signal no updates
  fi

  return 0 # Signal updates available
}

################################################################################
# UPDATE FUNCTIONS
################################################################################

update_core() {
  log_header "Updating Core Repository (Testing-Playerbot Branch)"

  if [[ "${DRY_RUN}" == "true" ]]; then
    log_info "[DRY RUN] Would fetch and pull Testing-Playerbot branch"
    git fetch origin Testing-Playerbot --dry-run 2>&1 | tee -a "${LOG_FILE}"
    return 0
  fi

  log_info "Fetching updates from origin/Testing-Playerbot..."
  if ! git fetch origin Testing-Playerbot 2>&1 | tee -a "${LOG_FILE}"; then
    log_error "Failed to fetch core updates"
    return 1
  fi

  log_info "Pulling updates..."
  if ! git pull origin Testing-Playerbot 2>&1 | tee -a "${LOG_FILE}"; then
    log_error "Failed to pull core updates"
    log_error "Attempting rollback..."
    git reset --hard ORIG_HEAD 2>&1 | tee -a "${LOG_FILE}"
    return 1
  fi

  log_success "Core repository updated successfully"
  return 0
}

update_submodules() {
  log_header "Updating Submodules"

  if [[ "${DRY_RUN}" == "true" ]]; then
    log_info "[DRY RUN] Would initialize and update all submodules"
    return 0
  fi

  # Check if .gitmodules exists
  if [[ ! -f "${SCRIPT_DIR}/.gitmodules" ]]; then
    log_warning "No .gitmodules file found - skipping submodule updates"
    return 0
  fi

  # Check for uninitialized submodules
  log_info "Checking for uninitialized submodules..."
  local uninitialized_count=0

  # Get list of submodules from .gitmodules
  while IFS= read -r line; do
    if [[ "$line" =~ path[[:space:]]*=[[:space:]]*(.*) ]]; then
      local submodule_path="${BASH_REMATCH[1]}"
      # Check if submodule directory exists and is initialized
      if [[ ! -d "${SCRIPT_DIR}/${submodule_path}/.git" ]] && [[ ! -f "${SCRIPT_DIR}/${submodule_path}/.git" ]]; then
        log_info "Found uninitialized submodule: ${submodule_path}"
        ((uninitialized_count++))
      fi
    fi
  done <"${SCRIPT_DIR}/.gitmodules"

  # Initialize submodules if any are missing
  if [[ ${uninitialized_count} -gt 0 ]]; then
    log_info "Initializing ${uninitialized_count} missing submodule(s)..."
    if ! git submodule init 2>&1 | tee -a "${LOG_FILE}"; then
      log_error "Failed to initialize submodules"
      return 1
    fi
    log_success "Submodules initialized successfully"
  else
    log_info "All submodules are already initialized"
  fi

  # Update all submodules to latest versions
  log_info "Updating all submodules to latest versions..."
  if ! git submodule update --init --remote --merge 2>&1 | tee -a "${LOG_FILE}"; then
    log_error "Failed to update submodules"
    log_error "Attempting rollback..."
    git submodule foreach 'git reset --hard ORIG_HEAD' 2>&1 | tee -a "${LOG_FILE}"
    return 1
  fi

  log_success "All submodules updated successfully"
  return 0
}

rebuild_docker() {
  log_header "Rebuilding Docker Containers"

  if [[ "${DRY_RUN}" == "true" ]]; then
    log_info "[DRY RUN] Would rebuild Docker containers"
    return 0
  fi

  log_info "Starting Docker Compose rebuild (timeout: ${BUILD_TIMEOUT}s)..."
  log_info "Build logs: ${BUILD_LOG_FILE}"

  local build_start=$(date +%s)

  # Run docker compose with timeout
  if timeout ${BUILD_TIMEOUT} docker compose up -d --build >"${BUILD_LOG_FILE}" 2>&1; then
    local build_end=$(date +%s)
    local build_duration=$((build_end - build_start))
    log_success "Docker rebuild completed in $((build_duration / 60))m $((build_duration % 60))s"
    return 0
  else
    local exit_code=$?
    if [[ ${exit_code} -eq 124 ]]; then
      log_error "Docker rebuild timed out after ${BUILD_TIMEOUT}s (60 minutes)"
    else
      log_error "Docker rebuild failed with exit code: ${exit_code}"
      log_error "Check build log for details: ${BUILD_LOG_FILE}"
      tail -50 "${BUILD_LOG_FILE}" | tee -a "${LOG_FILE}"
    fi
    return 1
  fi
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
  # Parse arguments
  for arg in "$@"; do
    case $arg in
    --git-only)
      GIT_ONLY=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help)
      show_help
      ;;
    *)
      log_error "Unknown option: $arg"
      show_help
      ;;
    esac
  done

  # Create logs directory
  mkdir -p "${LOGS_DIR}"

  # Start logging
  log_header "AzerothCore Testing Update Started"
  log_info "Environment: TESTING (Testing-Playerbot branch)"
  log_info "Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')"
  log_info "Mode: $([ "${GIT_ONLY}" == "true" ] && echo "Git-Only" || echo "Full Update + Rebuild")"
  log_info "Dry Run: $([ "${DRY_RUN}" == "true" ] && echo "Yes" || echo "No")"
  log_info "Log File: ${LOG_FILE}"

  # Validate environment
  if ! validate_environment; then
    log_error "Pre-flight checks failed"
    cleanup_old_logs
    exit 1
  fi

  # Capture versions before update
  capture_versions "before"

  # Update core
  if ! update_core; then
    log_error "Core update failed"
    cleanup_old_logs
    exit 1
  fi

  # Update submodules
  if ! update_submodules; then
    log_error "Submodule update failed"
    cleanup_old_logs
    exit 1
  fi

  # Capture versions after update
  capture_versions "after"

  # Generate change report
  if ! generate_change_report; then
    log_info "No updates were available"
    cleanup_old_logs
    exit 0
  fi

  # Rebuild Docker (unless git-only mode)
  if [[ "${GIT_ONLY}" == "false" ]]; then
    if ! rebuild_docker; then
      log_error "Docker rebuild failed"
      cleanup_old_logs
      exit 1
    fi
  else
    log_info "Skipping Docker rebuild (--git-only mode)"
  fi

  # Success!
  local duration=$(get_duration)

  log_header "Update Completed Successfully"
  log_success "Total duration: ${duration}"
  log_success "Updated repositories: ${#UPDATED_REPOS[@]}"
  for repo in "${UPDATED_REPOS[@]}"; do
    log_success "  - ${repo}"
  done

  # Cleanup old logs
  cleanup_old_logs

  log_success "All done!"
  exit 0
}

# Run main function
main "$@"
