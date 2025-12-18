#!/bin/bash
# Zone Bracket Configuration Parser
# Reads AiPlayerbot.ZoneBracket entries from playerbots.conf
# Outputs in various formats for use by other scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${1:-/root/testing-azerothcore-wotlk/env/dist/etc/modules/playerbots.conf}"

if [ ! -f "$CONFIG_FILE" ]; then
	echo "Error: Config file not found: $CONFIG_FILE" >&2
	exit 1
fi

# Parse zone brackets from config
declare -A ZONE_BRACKETS

while IFS= read -r line; do
	if [[ $line =~ ^AiPlayerbot\.ZoneBracket\.([0-9]+)[[:space:]]*=[[:space:]]*([0-9]+),([0-9]+) ]]; then
		zone_id="${BASH_REMATCH[1]}"
		min_level="${BASH_REMATCH[2]}"
		max_level="${BASH_REMATCH[3]}"
		ZONE_BRACKETS["$zone_id"]="$min_level,$max_level"
	fi
done <"$CONFIG_FILE"

# Function to get zones for a specific level
get_zones_for_level() {
	local target_level=$1
	local zones=()

	for zone_id in "${!ZONE_BRACKETS[@]}"; do
		IFS=',' read -r min_level max_level <<<"${ZONE_BRACKETS[$zone_id]}"
		if [ "$target_level" -ge "$min_level" ] && [ "$target_level" -le "$max_level" ]; then
			zones+=("$zone_id")
		fi
	done

	echo "${zones[@]}"
}

# Function to get level range for a zone
get_level_range_for_zone() {
	local zone_id=$1
	echo "${ZONE_BRACKETS[$zone_id]}"
}

# Function to check if a level is covered
is_level_covered() {
	local level=$1
	local zones=($(get_zones_for_level "$level"))
	[ ${#zones[@]} -gt 0 ]
}

# Export functions and data for sourcing
export -f get_zones_for_level
export -f get_level_range_for_zone
export -f is_level_covered

# Make ZONE_BRACKETS available to sourcing scripts
for zone_id in "${!ZONE_BRACKETS[@]}"; do
	export "ZONE_BRACKET_${zone_id}=${ZONE_BRACKETS[$zone_id]}"
done

# If script is sourced, don't run main logic
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	# Script is executed, not sourced

	case "${2:-}" in
	--json)
		# Output as JSON
		echo "{"
		first=true
		for zone_id in $(echo "${!ZONE_BRACKETS[@]}" | tr ' ' '\n' | sort -n); do
			IFS=',' read -r min_level max_level <<<"${ZONE_BRACKETS[$zone_id]}"
			if [ "$first" = true ]; then
				first=false
			else
				echo ","
			fi
			printf "  \"%s\": {\"min\": %s, \"max\": %s}" "$zone_id" "$min_level" "$max_level"
		done
		echo ""
		echo "}"
		;;

	--sql-case)
		# Output as SQL CASE statement for zone lookup
		echo "CASE zone"
		for zone_id in $(echo "${!ZONE_BRACKETS[@]}" | tr ' ' '\n' | sort -n); do
			IFS=',' read -r min_level max_level <<<"${ZONE_BRACKETS[$zone_id]}"
			printf "  WHEN %s THEN '%s,%s'\n" "$zone_id" "$min_level" "$max_level"
		done
		echo "  ELSE NULL"
		echo "END"
		;;

	--bash-array)
		# Output as bash associative array
		echo "declare -A ZONE_BRACKETS=("
		for zone_id in $(echo "${!ZONE_BRACKETS[@]}" | tr ' ' '\n' | sort -n); do
			printf "  [%s]=\"%s\"\n" "$zone_id" "${ZONE_BRACKETS[$zone_id]}"
		done
		echo ")"
		;;

	--list)
		# Simple listing
		for zone_id in $(echo "${!ZONE_BRACKETS[@]}" | tr ' ' '\n' | sort -n); do
			IFS=',' read -r min_level max_level <<<"${ZONE_BRACKETS[$zone_id]}"
			printf "Zone %4s: Levels %2s-%2s\n" "$zone_id" "$min_level" "$max_level"
		done
		;;

	--check-level)
		# Check if a specific level is covered
		level="${3:-}"
		if [ -z "$level" ]; then
			echo "Error: --check-level requires a level number" >&2
			exit 1
		fi

		if is_level_covered "$level"; then
			zones=($(get_zones_for_level "$level"))
			echo "Level $level is covered by ${#zones[@]} zone(s): ${zones[*]}"
			exit 0
		else
			echo "Level $level is NOT covered by any zone"
			exit 1
		fi
		;;

	--get-zones)
		# Get zones for a specific level
		level="${3:-}"
		if [ -z "$level" ]; then
			echo "Error: --get-zones requires a level number" >&2
			exit 1
		fi
		get_zones_for_level "$level"
		;;

	--coverage-report)
		# Generate coverage report
		echo "Zone Bracket Coverage Report"
		echo "=============================="
		echo ""

		uncovered=()
		for level in {1..80}; do
			if ! is_level_covered "$level"; then
				uncovered+=("$level")
			fi
		done

		if [ ${#uncovered[@]} -eq 0 ]; then
			echo "✅ All levels 1-80 are covered"
		else
			echo "❌ Uncovered levels: ${uncovered[*]}"
		fi

		echo ""
		echo "Total zones configured: ${#ZONE_BRACKETS[@]}"
		;;

	--help | *)
		cat <<'EOF'
Zone Bracket Configuration Parser

Usage: zone_bracket_parser.sh [config_file] [command] [args]

Commands:
  --json              Output zone brackets as JSON
  --sql-case          Output as SQL CASE statement
  --bash-array        Output as bash associative array
  --list              Simple listing of all zones
  --check-level N     Check if level N is covered
  --get-zones N       Get zone IDs for level N
  --coverage-report   Generate coverage report for levels 1-80
  --help              Show this help

If no command is specified, --list is used.

The script can also be sourced to make functions available:
  source zone_bracket_parser.sh [config_file]
  
Available functions when sourced:
  get_zones_for_level LEVEL
  get_level_range_for_zone ZONE_ID
  is_level_covered LEVEL

Example:
  ./zone_bracket_parser.sh --check-level 15
  ./zone_bracket_parser.sh --get-zones 30
  source ./zone_bracket_parser.sh && get_zones_for_level 50

EOF
		;;
	esac
fi
