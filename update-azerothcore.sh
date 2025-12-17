#!/bin/bash
################################################################################
# AzerothCore Automated Update Script
# 
# Description: Updates AzerothCore core and modules, rebuilds Docker containers,
#              and sends notifications to Uptime Kuma (which forwards to Discord)
#
# Usage:
#   ./update-azerothcore.sh              # Update + Rebuild (default)
#   ./update-azerothcore.sh --git-only   # Git updates only, skip rebuild
#   ./update-azerothcore.sh --dry-run    # Show what would be updated
#   ./update-azerothcore.sh --help       # Show this help
#
# Author: OpenCode AI Assistant
# Date: 2025-12-17
# Version: 2.0.0 (Production - with submodule fixes and backup integration)
################################################################################

set -euo pipefail  # Exit on error, undefined vars, pipe failures

################################################################################
# CONFIGURATION
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="$HOME/logs"
CONFIG_FILE="${SCRIPT_DIR}/.notification-config"
BACKUP_SCRIPT="${SCRIPT_DIR}/mysqlbackup.sh"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${LOGS_DIR}/update_${TIMESTAMP}.log"
BUILD_LOG_FILE="${LOGS_DIR}/build_${TIMESTAMP}.log"
START_TIME=$(date +%s)
BUILD_TIMEOUT=3600  # 60 minutes in seconds

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
NC='\033[0m'  # No Color
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
# NOTIFICATION FUNCTIONS
################################################################################

load_notification_config() {
    if [[ -f "${CONFIG_FILE}" ]]; then
        source "${CONFIG_FILE}"
        log_info "Loaded notification configuration"
    else
        log_warning "Notification config not found: ${CONFIG_FILE}"
        log_warning "Notifications will be disabled. Copy .notification-config.template to .notification-config"
        ENABLE_UPTIMEKUMA=false
    fi
}

send_uptimekuma_notification() {
    local status="$1"
    local message="$2"
    local ping="${3:-}"
    
    if [[ "${ENABLE_UPTIMEKUMA:-false}" != "true" ]]; then
        log_info "Uptime Kuma notifications disabled"
        return 0
    fi
    
    if [[ -z "${UPTIMEKUMA_PUSH_URL:-}" ]]; then
        log_warning "Uptime Kuma push URL not configured"
        return 0
    fi
    
    local url="${UPTIMEKUMA_PUSH_URL}?status=${status}&msg=${message}"
    if [[ -n "${ping}" ]]; then
        url="${url}&ping=${ping}"
    fi
    
    log_info "Sending notification to Uptime Kuma: status=${status}, msg=${message}"
    
    if /usr/bin/curl -fsS --retry 3 --max-time 10 "${url}" &>/dev/null; then
        log_success "Uptime Kuma notification sent successfully"
        return 0
    else
        log_error "Failed to send Uptime Kuma notification"
        return 1
    fi
}

################################################################################
# UTILITY FUNCTIONS
################################################################################

convert_ssh_to_https() {
    local url="$1"
    # Convert git@github.com:user/repo.git to https://github.com/user/repo.git
    if [[ "$url" =~ ^git@github\.com:(.*)$ ]]; then
        echo "https://github.com/${BASH_REMATCH[1]}"
    # Keep local paths as-is (for local repositories)
    elif [[ "$url" =~ ^/ ]] || [[ "$url" =~ ^file:// ]]; then
        echo "$url"
    else
        echo "$url"
    fi
}

get_duration() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    echo "${minutes}m ${seconds}s"
}

get_duration_ms() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    echo "$((duration * 1000))"
}

cleanup_old_logs() {
    log_info "Cleaning up logs older than 90 days..."
    /usr/bin/find "${LOGS_DIR}" -name "*.log" -type f -mtime +90 -delete 2>/dev/null || true
    local deleted_count=$(/usr/bin/find "${LOGS_DIR}" -name "*.log" -type f -mtime +90 2>/dev/null | wc -l)
    log_info "Cleaned up old logs (${deleted_count} files checked)"
}

show_help() {
    cat << 'HELPEOF'

AzerothCore Automated Update Script (Production)

USAGE:
    ./update-azerothcore.sh [OPTIONS]

OPTIONS:
    --git-only      Update Git repositories only, skip Docker rebuild
    --dry-run       Show what would be updated without making changes
    --help          Show this help message

EXAMPLES:
    ./update-azerothcore.sh                 # Update everything and rebuild (default)
    ./update-azerothcore.sh --git-only     # Update Git only, no rebuild
    ./update-azerothcore.sh --dry-run      # Preview updates

BRANCH:
    Playerbot (Production Environment)

LOGS:
    Location: ~/logs
    Retention: 90 days

BACKUP:
    MySQL backup runs automatically before updates

NOTIFICATIONS:
    Configure: .notification-config
    Flow: Script → Uptime Kuma → Discord

NOTE:
    This script will FORCE RESET all modules to match their remote branches,
    abandoning any local changes or commits. This ensures a clean update.

HELPEOF
    exit 0
}

################################################################################
# BACKUP FUNCTION
################################################################################

run_mysql_backup() {
    log_header "Running MySQL Backup"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would run MySQL backup script"
        return 0
    fi
    
    if [[ ! -f "${BACKUP_SCRIPT}" ]]; then
        log_error "Backup script not found: ${BACKUP_SCRIPT}"
        return 1
    fi
    
    if [[ ! -x "${BACKUP_SCRIPT}" ]]; then
        log_info "Making backup script executable..."
        /bin/chmod +x "${BACKUP_SCRIPT}"
    fi
    
    log_info "Starting MySQL backup (this may take several minutes)..."
    local backup_start=$(date +%s)
    
    if "${BACKUP_SCRIPT}" 2>&1 | tee -a "${LOG_FILE}"; then
        local backup_end=$(date +%s)
        local backup_duration=$((backup_end - backup_start))
        log_success "MySQL backup completed in $((backup_duration / 60))m $((backup_duration % 60))s"
        return 0
    else
        log_error "MySQL backup failed"
        return 1
    fi
}

################################################################################
# VALIDATION FUNCTIONS
################################################################################

validate_environment() {
    log_header "Pre-flight Checks (Production Environment)"
    
    # Check if we're in the correct directory
    if [[ ! -f "${SCRIPT_DIR}/.git/config" ]]; then
        log_error "Not in a git repository. Please run from azerothcore-wotlk directory"
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
    if ! /usr/bin/curl -fsS --max-time 5 https://github.com &>/dev/null; then
        log_error "No network connectivity to GitHub"
        return 1
    fi
    log_success "Network connectivity confirmed"
    
    # Check for local changes (excluding submodule pointer updates)
    log_info "Checking for local changes..."
    # Get status excluding submodule changes (modules/* directory)
    LOCAL_CHANGES=$(git status --porcelain | grep -v "^.[M] modules/" || true)
    if [[ -n "$LOCAL_CHANGES" ]]; then
        log_error "Local changes detected. Commit or stash changes before updating."
        log_error "Changed files:"
        echo "$LOCAL_CHANGES" | while read line; do
            log_error "  $line"
        done
        send_uptimekuma_notification "down" "Local%20changes%20detected%20-%20update%20blocked"
        exit 1
    fi
    # Log submodule changes if any (informational only)
    SUBMODULE_CHANGES=$(git status --porcelain | grep "^.[M] modules/" || true)
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
            local module_version=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
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
        return 1  # Signal no updates
    fi
    
    return 0  # Signal updates available
}

################################################################################
# MODULE MANAGEMENT FUNCTIONS
################################################################################

clone_missing_modules() {
    log_header "Checking for Missing Modules"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would check and clone missing modules"
        return 0
    fi
    
    # Check if .gitmodules exists
    if [[ ! -f "${SCRIPT_DIR}/.gitmodules" ]]; then
        log_warning "No .gitmodules file found - skipping module checks"
        return 0
    fi
    
    # Ensure git allows file protocol for local repositories
    local current_protocol_setting=$(git config --global --get protocol.file.allow 2>/dev/null || echo "not-set")
    if [[ "$current_protocol_setting" != "always" ]]; then
        log_info "Setting git to allow file:// protocol for local repositories..."
        git config --global protocol.file.allow always
        log_success "Git file protocol enabled"
    fi
    
    local cloned_count=0
    local skipped_count=0
    
    # Parse .gitmodules and clone missing modules
    local current_path=""
    local current_url=""
    local current_branch=""
    
    while IFS= read -r line; do
        # Extract submodule path
        if [[ "$line" =~ path[[:space:]]*=[[:space:]]*(.*) ]]; then
            current_path="${BASH_REMATCH[1]}"
            current_path="${current_path//\"/}"  # Remove quotes
        fi
        
        # Extract submodule URL
        if [[ "$line" =~ url[[:space:]]*=[[:space:]]*(.*) ]]; then
            current_url="${BASH_REMATCH[1]}"
            current_url="${current_url//\"/}"  # Remove quotes
            # Convert SSH to HTTPS if needed
            current_url=$(convert_ssh_to_https "$current_url")
        fi
        
        # Extract branch
        if [[ "$line" =~ branch[[:space:]]*=[[:space:]]*(.*) ]]; then
            current_branch="${BASH_REMATCH[1]}"
            current_branch="${current_branch//\"/}"  # Remove quotes
        fi
        
        # When we have path and url (branch is optional), check if module exists
        if [[ -n "$current_path" ]] && [[ -n "$current_url" ]]; then
            # If no branch specified, default to master
            if [[ -z "$current_branch" ]]; then
                current_branch="master"
                log_info "No branch specified for ${current_path}, defaulting to master"
            fi
            
            local full_path="${SCRIPT_DIR}/${current_path}"
            
            if [[ ! -d "${full_path}/.git" ]] && [[ ! -f "${full_path}/.git" ]]; then
                log_info "Module missing: ${current_path}"
                log_info "  URL: ${current_url}"
                log_info "  Branch: ${current_branch}"
                
                # Clone the module
                log_info "  Cloning module..."
                if git clone -b "${current_branch}" "${current_url}" "${full_path}" 2>&1 | tee -a "${LOG_FILE}"; then
                    log_success "  ✓ Cloned ${current_path}"
                    ((cloned_count++))
                else
                    log_error "  ✗ Failed to clone ${current_path}"
                    log_warning "  Continuing with other modules..."
                fi
            else
                ((skipped_count++))
            fi
            
            # Reset for next submodule
            current_path=""
            current_url=""
            current_branch=""
        fi
    done < "${SCRIPT_DIR}/.gitmodules"
    
    if [[ ${cloned_count} -gt 0 ]]; then
        log_success "Cloned ${cloned_count} missing module(s)"
    fi
    
    if [[ ${skipped_count} -gt 0 ]]; then
        log_info "${skipped_count} module(s) already exist"
    fi
    
    return 0
}

import_module_sql() {
    log_header "Importing Module SQL Files"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would import SQL files for new modules"
        return 0
    fi
    
    local imported_count=0
    
    cd "${SCRIPT_DIR}/modules" || return 1
    
    for module in mod-*; do
        if [[ -d "${module}/data/sql/characters/base" ]]; then
            log_info "Checking SQL files for ${module}..."
            
            # Import SQL files
            for sql_file in "${module}/data/sql/characters/base"/*.sql; do
                if [[ -f "$sql_file" ]]; then
                    log_info "  Importing: $(basename "$sql_file")"
                    if docker exec -i ac-database mysql -uroot -ppassword acore_characters < "$sql_file" 2>&1 | grep -v "password on the command line" | tee -a "${LOG_FILE}"; then
                        log_success "    ✓ Imported"
                        ((imported_count++))
                    else
                        # Check if error was just duplicate entry (already imported)
                        if [[ $? -eq 1 ]]; then
                            log_info "    (already imported or duplicate)"
                        else
                            log_warning "    Failed to import (may already exist)"
                        fi
                    fi
                fi
            done
        fi
    done
    
    cd "${SCRIPT_DIR}" || return 1
    
    if [[ ${imported_count} -gt 0 ]]; then
        log_success "Imported ${imported_count} SQL file(s)"
    else
        log_info "No new SQL files to import"
    fi
    
    return 0
}

################################################################################
# UPDATE FUNCTIONS
################################################################################

update_core() {
    log_header "Updating Core Repository (Playerbot Branch)"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would fetch and pull Playerbot branch"
        git fetch origin Playerbot --dry-run 2>&1 | tee -a "${LOG_FILE}"
        return 0
    fi
    
    log_info "Fetching updates from origin/Playerbot..."
    if ! git fetch origin Playerbot 2>&1 | tee -a "${LOG_FILE}"; then
        log_error "Failed to fetch core updates"
        return 1
    fi
    
    log_info "Pulling updates..."
    if ! git pull origin Playerbot 2>&1 | tee -a "${LOG_FILE}"; then
        log_error "Failed to pull core updates"
        log_error "Attempting rollback..."
        git reset --hard ORIG_HEAD 2>&1 | tee -a "${LOG_FILE}"
        return 1
    fi
    
    log_success "Core repository updated successfully"
    return 0
}

update_modules() {
    log_header "Updating Modules (Force Reset to Remote)"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would force reset all modules to remote branches"
        return 0
    fi
    
    cd "${SCRIPT_DIR}/modules" || return 1
    
    local update_count=0
    local error_count=0
    
    for module in mod-*; do
        if [[ -d "${module}/.git" ]]; then
            log_info "Updating ${module}..."
            cd "${module}" || continue
            
            # Get current branch
            local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
            log_info "  Branch: ${current_branch}"
            
            # Check for local changes and warn user
            local local_changes=$(git status --porcelain 2>/dev/null || true)
            if [[ -n "$local_changes" ]]; then
                log_warning "  Local changes detected - will be discarded:"
                echo "$local_changes" | head -n 5 | while read line; do
                    log_warning "    $line"
                done
            fi
            
            # Check if ahead of remote
            local ahead_count=$(git rev-list --count origin/${current_branch}..HEAD 2>/dev/null || echo "0")
            if [[ "$ahead_count" != "0" ]]; then
                log_warning "  Branch is ${ahead_count} commit(s) ahead of origin - will be reset"
            fi
            
            # Fetch updates
            if ! git fetch origin "${current_branch}" 2>&1 | tee -a "${LOG_FILE}"; then
                log_error "  ✗ Failed to fetch ${module}"
                ((error_count++))
                cd ..
                continue
            fi
            
            # Force reset to remote branch (abandoning local changes)
            log_info "  Force resetting to origin/${current_branch}..."
            if git reset --hard "origin/${current_branch}" 2>&1 | tee -a "${LOG_FILE}"; then
                # Clean any untracked files
                git clean -fd 2>&1 | tee -a "${LOG_FILE}"
                log_success "  ✓ Reset ${module} to origin/${current_branch}"
                ((update_count++))
            else
                log_error "  ✗ Failed to reset ${module}"
                ((error_count++))
            fi
            
            cd ..
        fi
    done
    
    cd "${SCRIPT_DIR}" || return 1
    
    log_info "Updated ${update_count} module(s)"
    if [[ ${error_count} -gt 0 ]]; then
        log_warning "${error_count} module(s) failed to update"
    fi
    
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
    if timeout ${BUILD_TIMEOUT} docker compose up -d --build > "${BUILD_LOG_FILE}" 2>&1; then
        local build_end=$(date +%s)
        local build_duration=$((build_end - build_start))
        log_success "Docker rebuild completed in $((build_duration / 60))m $((build_duration % 60))s"
        return 0
    else
        local exit_code=$?
        if [[ ${exit_code} -eq 124 ]]; then
            log_error "Docker rebuild timed out after ${BUILD_TIMEOUT}s (60 minutes)"
            send_uptimekuma_notification "down" "Build%20timeout%20after%2060%20minutes" ""
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
    log_header "AzerothCore Production Update Started"
    log_info "Environment: PRODUCTION (Playerbot branch)"
    log_info "Timestamp: $(date '+%Y-%m-%d %H:%M:%S %Z')"
    log_info "Mode: $([ "${GIT_ONLY}" == "true" ] && echo "Git-Only" || echo "Full Update + Rebuild")"
    log_info "Dry Run: $([ "${DRY_RUN}" == "true" ] && echo "Yes" || echo "No")"
    log_info "Log File: ${LOG_FILE}"
    log_warning "Submodules will be FORCE RESET to remote branches (local changes discarded)"
    
    # Load notification config
    load_notification_config
    
    # Run MySQL backup FIRST
    if ! run_mysql_backup; then
        log_error "MySQL backup failed - aborting update for safety"
        send_uptimekuma_notification "down" "MySQL%20backup%20failed%20-%20update%20aborted"
        cleanup_old_logs
        exit 1
    fi
    
    # Validate environment
    if ! validate_environment; then
        log_error "Pre-flight checks failed"
        send_uptimekuma_notification "down" "Pre-flight%20checks%20failed"
        cleanup_old_logs
        exit 1
    fi
    
    # Clone any missing modules FIRST
    if ! clone_missing_modules; then
        log_error "Module cloning failed"
        send_uptimekuma_notification "down" "Module%20cloning%20failed"
        cleanup_old_logs
        exit 1
    fi
    
    # Import SQL for new modules
    if [[ "${GIT_ONLY}" == "false" ]] && [[ "${DRY_RUN}" == "false" ]]; then
        if ! import_module_sql; then
            log_warning "SQL import had some issues, continuing..."
        fi
    fi
    
    # Capture versions before update
    capture_versions "before"
    
    # Update core
    if ! update_core; then
        log_error "Core update failed"
        send_uptimekuma_notification "down" "Core%20update%20failed"
        cleanup_old_logs
        exit 1
    fi
    
    # Update modules (using force reset method)
    if ! update_modules; then
        log_error "Module update failed"
        send_uptimekuma_notification "down" "Module%20update%20failed"
        cleanup_old_logs
        exit 1
    fi
    
    # Capture versions after update
    capture_versions "after"
    
    # Generate change report
    if ! generate_change_report; then
        log_info "No updates were available"
        local duration=$(get_duration)
        local duration_ms=$(get_duration_ms)
        send_uptimekuma_notification "up" "No%20updates%20available" "${duration_ms}"
        cleanup_old_logs
        exit 0
    fi
    
    # Rebuild Docker (unless git-only mode)
    if [[ "${GIT_ONLY}" == "false" ]]; then
        if ! rebuild_docker; then
            log_error "Docker rebuild failed"
            send_uptimekuma_notification "down" "Docker%20rebuild%20failed"
            cleanup_old_logs
            exit 1
        fi
    else
        log_info "Skipping Docker rebuild (--git-only mode)"
    fi
    
    # Success!
    local duration=$(get_duration)
    local duration_ms=$(get_duration_ms)
    
    log_header "Update Completed Successfully"
    log_success "Total duration: ${duration}"
    log_success "Updated repositories: ${#UPDATED_REPOS[@]}"
    for repo in "${UPDATED_REPOS[@]}"; do
        log_success "  - ${repo}"
    done
    
    # Send success notification
    local mode=$([ "${GIT_ONLY}" == "true" ] && echo "Git-only" || echo "Full")
    local msg="Update%20completed%20(${mode})%20-%20${#UPDATED_REPOS[@]}%20repos%20updated"
    send_uptimekuma_notification "up" "${msg}" "${duration_ms}"
    
    # Cleanup old logs
    cleanup_old_logs
    
    log_success "All done!"
    exit 0
}

# Run main function
main "$@"
