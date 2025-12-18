#!/bin/bash
# Production Bot Relocation Script - Config-Driven
# Reads zone brackets from playerbots.conf and uses database zone coordinates
# Ensures complete alignment between relocation and teleportation systems

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${CONFIG_FILE:-/root/testing-azerothcore-wotlk/env/dist/etc/modules/playerbots.conf}"
PARSER_SCRIPT="${SCRIPT_DIR}/zone_bracket_parser.sh"

echo "=========================================="
echo "Config-Driven Bot Relocation Script V11"
echo "=========================================="
echo "Config: $CONFIG_FILE"
echo "Time: $(date)"
echo ""

# Check for required MySQL password
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
	echo "Error: MYSQL_ROOT_PASSWORD environment variable not set"
	exit 1
fi

# Source the zone bracket parser
if [ ! -f "$PARSER_SCRIPT" ]; then
	echo "Error: Zone bracket parser not found: $PARSER_SCRIPT"
	echo "Please ensure zone_bracket_parser.sh is in the same directory"
	exit 1
fi

source "$PARSER_SCRIPT" "$CONFIG_FILE"

# Verify coverage
echo "Verifying zone bracket coverage for levels 1-80..."
uncovered_levels=()
for level in {1..80}; do
	if ! is_level_covered "$level"; then
		uncovered_levels+=("$level")
	fi
done

if [ ${#uncovered_levels[@]} -gt 0 ]; then
	echo "❌ ERROR: The following levels are not covered by zone brackets:"
	echo "   ${uncovered_levels[*]}"
	echo ""
	echo "Please update $CONFIG_FILE to add zone brackets for these levels."
	echo "Example: AiPlayerbot.ZoneBracket.12 = 1,12"
	exit 1
fi

echo "✅ All levels 1-80 are covered"
echo ""

# Define zone data with coordinates (hardcoded safe locations per zone)
declare -A ZONE_DATA

# Starter Zones
ZONE_DATA[1]="0:-6240.32:331.03:382.76"         # Dun Morogh
ZONE_DATA[12]="0:-8949.95:-132.49:83.53"        # Elwynn Forest
ZONE_DATA[14]="1:-618.52:-4251.70:38.72"        # Durotar
ZONE_DATA[85]="0:1681.00:1667.75:121.04"        # Tirisfal Glades
ZONE_DATA[141]="1:10311.30:832.46:1326.41"      # Teldrassil
ZONE_DATA[215]="1:-2917.58:-257.98:52.97"       # Mulgore
ZONE_DATA[3430]="530:10349.60:-6357.29:33.13"   # Eversong Woods
ZONE_DATA[3524]="530:-3961.67:-13931.20:100.62" # Azuremyst Isle

# Secondary Zones
ZONE_DATA[17]="1:-450.95:-2643.28:96.23"       # Barrens
ZONE_DATA[40]="0:-10628.69:1055.96:36.24"      # Westfall
ZONE_DATA[38]="0:-5421.91:-2929.51:346.97"     # Loch Modan
ZONE_DATA[130]="0:505.13:1504.63:127.13"       # Silverpine Forest
ZONE_DATA[148]="1:6463.25:683.14:8.79"         # Darkshore
ZONE_DATA[3433]="530:7595.73:-6819.74:84.50"   # Ghostlands
ZONE_DATA[3525]="530:-2095.70:-11841.10:51.17" # Bloodmyst Isle

# Mid-Level Zones
ZONE_DATA[10]="0:-10515.92:-1281.91:38.38"  # Duskwood
ZONE_DATA[11]="0:-3517.75:-913.40:8.86"     # Wetlands
ZONE_DATA[44]="0:-9449.06:-2202.45:93.56"   # Redridge Mountains
ZONE_DATA[267]="0:-385.80:-511.74:53.63"    # Hillsbrad Foothills
ZONE_DATA[331]="1:2744.80:-1373.86:107.83"  # Ashenvale
ZONE_DATA[400]="1:-5375.90:-2509.90:-40.40" # Thousand Needles
ZONE_DATA[406]="1:1145.53:534.30:16.32"     # Stonetalon Mountains

# Higher Mid-Level Zones
ZONE_DATA[3]="0:-6782.41:-3391.77:241.68"  # Badlands
ZONE_DATA[8]="0:-10368.60:-2731.30:21.65"  # Swamp of Sorrows
ZONE_DATA[15]="1:-2967.00:-3661.00:33.78"  # Dustwallow Marsh
ZONE_DATA[16]="1:3341.30:-4603.80:92.32"   # Azshara
ZONE_DATA[33]="0:-11921.70:-59.54:39.73"   # Stranglethorn Vale
ZONE_DATA[45]="0:-1513.99:-2627.51:41.34"  # Arathi Highlands
ZONE_DATA[47]="0:-345.30:-4032.40:122.36"  # Hinterlands
ZONE_DATA[51]="0:-6686.33:-1193.93:240.02" # Searing Gorge
ZONE_DATA[357]="1:-4808.31:1040.51:103.77" # Feralas
ZONE_DATA[405]="1:-656.06:1510.58:90.45"   # Desolace
ZONE_DATA[440]="1:-6823.28:770.62:57.88"   # Tanaris

# High-Level Classic Zones
ZONE_DATA[4]="0:-11184.70:-3019.79:7.29"     # Blasted Lands
ZONE_DATA[28]="0:1743.69:-1723.86:59.57"     # Western Plaguelands
ZONE_DATA[46]="0:-7979.78:-2105.72:127.92"   # Burning Steppes
ZONE_DATA[139]="0:2280.64:-5275.05:82.06"    # Eastern Plaguelands
ZONE_DATA[361]="1:5809.55:-1822.45:374.49"   # Felwood
ZONE_DATA[490]="1:-6291.55:-1158.62:-258.17" # Un'Goro Crater
ZONE_DATA[618]="1:6726.54:-4645.06:720.80"   # Winterspring
ZONE_DATA[1377]="1:-7181.67:1653.26:4.48"    # Silithus

# TBC Zones
ZONE_DATA[3483]="530:-360.67:3071.92:-15.10"  # Hellfire Peninsula
ZONE_DATA[3518]="530:-1769.32:7152.56:-10.30" # Nagrand
ZONE_DATA[3519]="530:-2538.09:4277.22:20.63"  # Terokkar Forest
ZONE_DATA[3520]="530:-3881.34:2150.38:4.53"   # Shadowmoon Valley
ZONE_DATA[3521]="530:254.93:7862.00:22.44"    # Zangarmarsh
ZONE_DATA[3522]="530:2029.75:4425.37:156.97"  # Blade's Edge Mountains
ZONE_DATA[3523]="530:3087.22:3681.85:143.20"  # Netherstorm
ZONE_DATA[4080]="530:12806.50:-6911.40:41.11" # Isle of Quel'Danas
ZONE_DATA[3703]="530:-1838.16:5301.79:-12.43" # Shattrath City

# WotLK Zones
ZONE_DATA[3537]="571:2954.24:5379.13:60.45"  # Borean Tundra
ZONE_DATA[495]="571:682.00:-3978.00:230.16"  # Howling Fjord
ZONE_DATA[65]="571:3551.15:274.87:-52.14"    # Dragonblight
ZONE_DATA[66]="571:5770.25:-2913.97:292.41"  # Zul'Drak
ZONE_DATA[67]="571:6120.46:-1025.00:408.39"  # Storm Peaks
ZONE_DATA[210]="571:8515.65:714.15:547.48"   # Icecrown
ZONE_DATA[394]="571:4017.75:-3404.17:290.00" # Grizzly Hills
ZONE_DATA[3711]="571:5614.67:5818.34:-74.78" # Sholazar Basin
ZONE_DATA[2817]="571:5722.14:1016.23:175.63" # Crystalsong Forest
ZONE_DATA[4197]="571:5132.66:2840.52:408.5"  # Wintergrasp
ZONE_DATA[4395]="571:5804.15:624.77:647.77"  # Dalaran

# Race to faction mapping
declare -A RACE_FACTION
RACE_FACTION[1]="alliance"  # Human
RACE_FACTION[3]="alliance"  # Dwarf
RACE_FACTION[4]="alliance"  # Night Elf
RACE_FACTION[7]="alliance"  # Gnome
RACE_FACTION[11]="alliance" # Draenei
RACE_FACTION[2]="horde"     # Orc
RACE_FACTION[5]="horde"     # Undead
RACE_FACTION[6]="horde"     # Tauren
RACE_FACTION[8]="horde"     # Troll
RACE_FACTION[10]="horde"    # Blood Elf

# Starter zones by race
declare -A RACE_STARTER_ZONE
RACE_STARTER_ZONE[1]=12    # Human -> Elwynn Forest
RACE_STARTER_ZONE[3]=1     # Dwarf -> Dun Morogh
RACE_STARTER_ZONE[4]=141   # Night Elf -> Teldrassil
RACE_STARTER_ZONE[7]=1     # Gnome -> Dun Morogh
RACE_STARTER_ZONE[11]=3524 # Draenei -> Azuremyst Isle
RACE_STARTER_ZONE[2]=14    # Orc -> Durotar
RACE_STARTER_ZONE[5]=85    # Undead -> Tirisfal Glades
RACE_STARTER_ZONE[6]=215   # Tauren -> Mulgore
RACE_STARTER_ZONE[8]=14    # Troll -> Durotar
RACE_STARTER_ZONE[10]=3430 # Blood Elf -> Eversong Woods

# Faction-preferred zones
declare -A ALLIANCE_ZONES
ALLIANCE_ZONES[40]=1   # Westfall
ALLIANCE_ZONES[10]=1   # Duskwood
ALLIANCE_ZONES[45]=1   # Arathi Highlands
ALLIANCE_ZONES[38]=1   # Loch Modan
ALLIANCE_ZONES[148]=1  # Darkshore
ALLIANCE_ZONES[3525]=1 # Bloodmyst Isle
ALLIANCE_ZONES[11]=1   # Wetlands
ALLIANCE_ZONES[44]=1   # Redridge Mountains

declare -A HORDE_ZONES
HORDE_ZONES[17]=1   # Barrens
HORDE_ZONES[331]=1  # Ashenvale
HORDE_ZONES[130]=1  # Silverpine Forest
HORDE_ZONES[3433]=1 # Ghostlands
HORDE_ZONES[267]=1  # Hillsbrad Foothills

# Function to select best zone for race/level
select_zone_for_bot() {
	local race=$1
	local level=$2

	local zones=($(get_zones_for_level "$level"))

	if [ ${#zones[@]} -eq 0 ]; then
		return 1
	fi

	# Check starter zone first
	local starter_zone=${RACE_STARTER_ZONE[$race]}
	if [ -n "$starter_zone" ]; then
		for zone in "${zones[@]}"; do
			if [ "$zone" = "$starter_zone" ]; then
				echo "$zone"
				return 0
			fi
		done
	fi

	# Check faction-preferred zones
	local faction=${RACE_FACTION[$race]}
	if [ "$faction" = "alliance" ]; then
		for zone in "${zones[@]}"; do
			if [ -n "${ALLIANCE_ZONES[$zone]}" ]; then
				echo "$zone"
				return 0
			fi
		done
	else
		for zone in "${zones[@]}"; do
			if [ -n "${HORDE_ZONES[$zone]}" ]; then
				echo "$zone"
				return 0
			fi
		done
	fi

	# Return first available zone
	echo "${zones[0]}"
	return 0
}

echo "Generating SQL relocation script..."
SQL_FILE="/tmp/config_driven_relocate_$(date +%s).sql"

cat >"$SQL_FILE" <<'SQLHEADER'
USE acore_characters;

-- Set all bots offline before relocation
UPDATE characters 
SET online = 0 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);

START TRANSACTION;

SQLHEADER

# Generate relocation SQL for each race/level combination
for level in {1..80}; do
	echo "" >>"$SQL_FILE"
	echo "-- ============================================================================" >>"$SQL_FILE"
	echo "-- LEVEL $level" >>"$SQL_FILE"
	echo "-- ============================================================================" >>"$SQL_FILE"

	for race in 1 2 3 4 5 6 7 8 10 11; do
		selected_zone=$(select_zone_for_bot "$race" "$level")

		if [ -z "$selected_zone" ] || [ -z "${ZONE_DATA[$selected_zone]}" ]; then
			echo "-- Race $race Level $level: No zone data available" >>"$SQL_FILE"
			continue
		fi

		IFS=':' read -r map_id pos_x pos_y pos_z <<<"${ZONE_DATA[$selected_zone]}"

		cat >>"$SQL_FILE" <<SQLUPDATE

-- Race $race, Level $level -> Zone $selected_zone
UPDATE characters
SET position_x = $pos_x, position_y = $pos_y, position_z = $pos_z,
    map = $map_id, zone = $selected_zone, orientation = 0
WHERE level = $level AND race = $race
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);

SQLUPDATE
	done
done

cat >>"$SQL_FILE" <<'SQLFOOTER'

COMMIT;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Config-Driven Bot Relocation V11 Complete' as status, 
       NOW() as timestamp,
       COUNT(*) as total_bots
FROM characters 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);

-- Distribution by level bracket
SELECT 
    CASE 
        WHEN level BETWEEN 1 AND 9 THEN '1-9'
        WHEN level BETWEEN 10 AND 19 THEN '10-19'
        WHEN level BETWEEN 20 AND 29 THEN '20-29'
        WHEN level BETWEEN 30 AND 39 THEN '30-39'
        WHEN level BETWEEN 40 AND 49 THEN '40-49'
        WHEN level BETWEEN 50 AND 59 THEN '50-59'
        WHEN level = 60 THEN '60'
        WHEN level BETWEEN 61 AND 69 THEN '61-69'
        WHEN level = 70 THEN '70'
        WHEN level BETWEEN 71 AND 79 THEN '71-79'
        WHEN level = 80 THEN '80'
    END as level_bracket,
    COUNT(*) as bot_count
FROM characters 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0)
GROUP BY level_bracket
ORDER BY MIN(level);

SQLFOOTER

echo ""
echo "✅ SQL script generated: $SQL_FILE"
echo ""
echo "Executing relocation..."

mysql -h testing-ac-database -uroot -p"$MYSQL_ROOT_PASSWORD" <"$SQL_FILE" 2>&1 | grep -v "Using a password"

echo ""
echo "✅ Bot relocation complete!"
echo ""
echo "Summary:"
echo "  - Used zone brackets from: $CONFIG_FILE"
echo "  - All levels 1-80 processed"
echo "  - Zone selection based on race and faction preferences"
echo ""
