#!/bin/bash
# Zone Bracket Coverage Analysis Script
# Analyzes playerbots.conf to verify all levels 1-80 are covered

CONFIG_FILE="$1"

if [ -z "$CONFIG_FILE" ]; then
	echo "Usage: $0 <path_to_playerbots.conf>"
	exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
	echo "Error: Config file not found: $CONFIG_FILE"
	exit 1
fi

echo "=========================================="
echo "Zone Bracket Coverage Analysis"
echo "=========================================="
echo ""

# Extract zone brackets from config
echo "Extracting zone brackets from config..."
declare -A zone_brackets
while IFS= read -r line; do
	if [[ $line =~ ^AiPlayerbot\.ZoneBracket\.([0-9]+)[[:space:]]*=[[:space:]]*([0-9]+),([0-9]+) ]]; then
		zone_id="${BASH_REMATCH[1]}"
		min_level="${BASH_REMATCH[2]}"
		max_level="${BASH_REMATCH[3]}"
		zone_brackets["$zone_id"]="$min_level,$max_level"
	fi
done <"$CONFIG_FILE"

echo "Found ${#zone_brackets[@]} zone bracket entries"
echo ""

# Create level coverage array
declare -A level_coverage
for level in {1..80}; do
	level_coverage[$level]=""
done

# Map zones to levels
for zone_id in "${!zone_brackets[@]}"; do
	IFS=',' read -r min_level max_level <<<"${zone_brackets[$zone_id]}"
	for ((level = min_level; level <= max_level; level++)); do
		if [ -n "${level_coverage[$level]}" ]; then
			level_coverage[$level]="${level_coverage[$level]},${zone_id}"
		else
			level_coverage[$level]="${zone_id}"
		fi
	done
done

# Check coverage
echo "=========================================="
echo "Level Coverage Analysis"
echo "=========================================="
echo ""

uncovered_levels=()
for level in {1..80}; do
	if [ -z "${level_coverage[$level]}" ]; then
		uncovered_levels+=($level)
	fi
done

if [ ${#uncovered_levels[@]} -eq 0 ]; then
	echo "✅ SUCCESS: All levels 1-80 are covered!"
else
	echo "❌ GAPS FOUND: ${#uncovered_levels[@]} levels are not covered"
	echo ""
	echo "Uncovered levels:"
	for level in "${uncovered_levels[@]}"; do
		echo "  Level $level"
	done
fi

echo ""
echo "=========================================="
echo "Coverage by Expansion"
echo "=========================================="
echo ""

# Classic (1-60)
classic_covered=0
for level in {1..60}; do
	if [ -n "${level_coverage[$level]}" ]; then
		((classic_covered++))
	fi
done
echo "Classic (1-60):  $classic_covered/60 levels covered"

# TBC (58-70)
tbc_covered=0
for level in {58..70}; do
	if [ -n "${level_coverage[$level]}" ]; then
		((tbc_covered++))
	fi
done
echo "TBC (58-70):     $tbc_covered/13 levels covered"

# WotLK (68-80)
wotlk_covered=0
for level in {68..80}; do
	if [ -n "${level_coverage[$level]}" ]; then
		((wotlk_covered++))
	fi
done
echo "WotLK (68-80):   $wotlk_covered/13 levels covered"

echo ""
echo "=========================================="
echo "Detailed Level Coverage"
echo "=========================================="
echo ""

for level in {1..80}; do
	zone_count=0
	if [ -n "${level_coverage[$level]}" ]; then
		IFS=',' read -ra zones <<<"${level_coverage[$level]}"
		zone_count=${#zones[@]}
	fi

	if [ $zone_count -eq 0 ]; then
		printf "Level %2d: ❌ NO COVERAGE\n" $level
	else
		printf "Level %2d: ✅ %2d zone(s)\n" $level $zone_count
	fi
done

echo ""
echo "=========================================="
echo "Zone Bracket Listing"
echo "=========================================="
echo ""

# Sort zone IDs numerically and display
for zone_id in $(echo "${!zone_brackets[@]}" | tr ' ' '\n' | sort -n); do
	IFS=',' read -r min_level max_level <<<"${zone_brackets[$zone_id]}"
	printf "Zone %4d: Levels %2d-%2d\n" $zone_id $min_level $max_level
done

echo ""
echo "Analysis complete."
