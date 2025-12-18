#!/bin/bash

# Config-driven bot relocation script v11 (Fixed IFS handling)
# Uses zone brackets from playerbots.conf as single source of truth

set -uo pipefail

# Save original IFS
ORIG_IFS="$IFS"

# Use absolute paths for Docker container
WORKSPACE="${WORKSPACE_DIR:-/workspace}"
CONFIG_FILE="${1:-$WORKSPACE/env/dist/etc/modules/playerbots.conf}"
PARSER_SCRIPT="$WORKSPACE/zone_bracket_parser.sh"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

if [[ ! -f "$PARSER_SCRIPT" ]]; then
    echo "❌ Parser script not found: $PARSER_SCRIPT"
    exit 1
fi

# Check MySQL password
if [[ -z "${MYSQL_ROOT_PASSWORD:-}" ]]; then
    echo "❌ MYSQL_ROOT_PASSWORD environment variable not set"
    exit 1
fi

echo "Checking zone bracket coverage..."

# Use parser to check coverage
COVERAGE_CHECK=$(bash "$PARSER_SCRIPT" "$CONFIG_FILE" --coverage-report | grep "NOT COVERED" || true)
if [[ -n "$COVERAGE_CHECK" ]]; then
    echo "❌ Coverage gaps detected:"
    bash "$PARSER_SCRIPT" "$CONFIG_FILE" --coverage-report
    exit 1
fi
echo "✅ All levels 1-80 are covered"

# Safe coordinates for each zone (zone_id => "map,x,y,z,orientation")
declare -A ZONE_COORDS=(
    # Starter Zones (1-12)
    [1]="0,-8949.95,-132.493,83.5312,0"      # Dun Morogh (Dwarf/Gnome)
    [12]="0,-8949.95,-132.493,83.5312,0"     # Elwynn Forest (Human)
    [14]="1,228.978,-4741.87,10.1027,0"      # Durotar (Orc/Troll)
    [85]="0,1676.71,1678.31,121.67,2.70526"  # Tirisfal Glades (Undead)
    [141]="1,10311.3,832.463,1326.41,5.69632" # Teldrassil (Night Elf)
    [215]="1,-2917.58,-257.98,52.9968,0"     # Mulgore (Tauren)
    [3430]="530,10324.5,-6294.71,35.4596,0"  # Eversong Woods (Blood Elf)
    [3524]="530,-3961.67,-13931.2,100.615,0" # Azuremyst Isle (Draenei)
    
    # Alliance Leveling Zones
    [38]="0,-10515.7,-1281.91,38.8647,1.60093"  # Loch Modan (10-20)
    [40]="0,-10515.7,-1281.91,38.8647,1.60093"  # Westfall (10-20)
    [130]="0,-234.675,1561.63,76.8921,1.24031"  # Silverpine Forest (10-20)
    [148]="0,-234.675,1561.63,76.8921,1.24031"  # Darkshore (10-20)
    [16]="0,-6240.32,331.033,382.758,0"         # Arathi Highlands (20-30)
    [10]="0,-11122.9,-2877.36,9.81962,0"        # Duskwood (18-30)
    [11]="0,-11122.9,-2877.36,9.81962,0"        # Wetlands (20-30)
    [44]="0,-4808.31,-2742.45,316.907,0"        # Redridge Mountains (15-25)
    [267]="1,-6940.91,805.906,8.65152,0"        # Silithus (55-60) - FALLBACK
    [405]="0,-5405.85,-2894.17,341.972,5.48033" # Desolace (30-40)
    [15]="0,-5405.85,-2894.17,341.972,5.48033"  # Dustwallow Marsh (35-45)
    [8]="0,-7179.34,-3815.61,8.36981,0"         # Swamp of Sorrows (35-45)
    [3]="0,-9447.8,-2270.85,71.8224,0"          # Badlands (35-45)
    [4]="0,-7179.34,-3815.61,8.36981,0"         # Blasted Lands (45-55)
    [28]="0,-5837.23,-3979.89,8.3481,0"         # Western Plaguelands (51-58)
    [139]="0,-5405.85,-2894.17,341.972,5.48033" # Eastern Plaguelands (53-60)
    [51]="0,-6940.91,805.906,8.65152,0"         # Searing Gorge (43-50)
    [46]="0,-6940.91,805.906,8.65152,0"         # Burning Steppes (50-58)
    
    # Horde Leveling Zones
    [17]="1,328.558,-4662.38,16.4014,0"         # Barrens (10-25)
    [331]="1,328.558,-4662.38,16.4014,0"        # Ashenvale (18-30)
    [400]="1,-2473.87,-501.225,-9.42465,0"      # Thousand Needles (25-35)
    [406]="1,-4408.4,3476.7,12.1314,0"          # Stonetalon Mountains (15-27)
    [490]="1,-7596.65,-2086.87,8.87721,0"       # Un'Goro Crater (48-55)
    [618]="1,-3447.63,1004.51,12.8124,0"        # Winterspring (55-60)
    [361]="1,-3447.63,1004.51,12.8124,0"        # Felwood (48-55)
    [357]="1,6463.25,-4206.55,763.956,0"        # Feralas (40-50)
    [440]="1,-1279.16,118.438,131.442,5.20165"  # Tanaris (40-50)
    [41]="0,-11122.9,-2877.36,9.81962,0"        # Deadwind Pass (55-60)
    [45]="0,-10684.9,-1329.52,240.604,0"        # Arathi Highlands (25-35)
    [47]="0,-7596.65,-2086.87,8.87721,0"        # Hinterlands (30-50)
    
    # Neutral/Contested Zones
    [33]="0,-10997.9,-3463.62,0.0,0"            # Stranglethorn Vale (30-45)
    [36]="530,-211.071,2506.6,87.7179,0"        # Alterac Mountains (30-40)
    [2597]="530,-211.071,2506.6,87.7179,0"      # Alterac Valley (various)
    [3518]="530,-1887.62,5359.51,-12.4279,4.926" # Nagrand (64-67)
    [3520]="530,2029.75,6232.07,133.942,1.30088" # Shadowmoon Valley (67-70)
    [3519]="530,-2266.23,4244.73,1.47223,3.68426" # Terokkar Forest (62-65)
    [3521]="530,193.126,7648.13,22.1329,0.05992" # Zangarmarsh (60-64)
    [3522]="530,-527.99,8681.39,23.5396,4.858"   # Blade's Edge Mountains (65-68)
    [3523]="530,2860.75,3689.91,143.851,3.51389" # Netherstorm (67-70)
    [3525]="530,-1887.62,5359.51,-12.4279,4.926" # Hellfire Peninsula (58-63)
    [65]="0,-5163.54,925.423,257.181,1.57423"   # Dragonblight (71-74)
    [66]="571,3230.23,-672.125,164.989,5.55055" # Zul'Drak (74-77)
    [67]="571,5614.67,5818.44,-69.7884,0.422444" # Storm Peaks (76-80)
    [210]="571,5483.35,4840.66,-195.348,4.66446" # Icecrown (77-80)
    [394]="571,5855.22,445.158,658.754,1.66789" # Grizzly Hills (73-75)
    [495]="571,2954.24,5379.13,60.4538,2.55544" # Howling Fjord (68-72)
    [2817]="571,5855.22,445.158,658.754,1.66789" # Crystalsong Forest (74-80)
    [3537]="571,5722.12,1016.53,175.066,4.64149" # Borean Tundra (68-72)
    [4197]="571,5722.12,1016.53,175.066,4.64149" # Wintergrasp (various)
    [3711]="571,5829.85,588.053,660.939,1.66953" # Sholazar Basin (75-78)
    [4395]="571,5722.12,1016.53,175.066,4.64149" # Dalaran (74-80)
    [1377]="1,-6940.91,805.906,8.65152,0"       # Silithus (FALLBACK - missing coords)
)

# Race to starter zone mapping
declare -A RACE_ZONES=(
    [1]=12    # Human -> Elwynn Forest
    [2]=14    # Orc -> Durotar
    [3]=1     # Dwarf -> Dun Morogh
    [4]=141   # Night Elf -> Teldrassil
    [5]=85    # Undead -> Tirisfal Glades
    [6]=215   # Tauren -> Mulgore
    [7]=1     # Gnome -> Dun Morogh
    [8]=14    # Troll -> Durotar
    [10]=3430 # Blood Elf -> Eversong Woods
    [11]=3524 # Draenei -> Azuremyst Isle
)

DB_HOST="${DB_HOST:-testing-ac-database}"
DB_PORT="${DB_PORT:-3306}"
MYSQL_CMD="mysql -h$DB_HOST -P$DB_PORT -uroot -p$MYSQL_ROOT_PASSWORD"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SQL_FILE="/tmp/config_driven_relocate_${TIMESTAMP}.sql"

echo "Generating SQL from config-defined zone brackets..."
echo "-- Config-driven bot relocation SQL" > "$SQL_FILE"
echo "-- Generated: $(date)" >> "$SQL_FILE"
echo "" >> "$SQL_FILE"

TOTAL_UPDATES=0

for LEVEL in {1..80}; do
    [[ $(($LEVEL % 10)) -eq 0 ]] && echo "Progress: Reached level $LEVEL"
    # Get zones for this level from config
    ZONES=$(bash "$PARSER_SCRIPT" "$CONFIG_FILE" --get-zones $LEVEL)
    
    if [[ -z "$ZONES" ]]; then
        echo "⚠️  Level $LEVEL: No zones found in config"
        continue
    fi
    
    # Convert to array - restore IFS after read
    IFS=" " read -ra ZONE_ARRAY <<< "$ZONES"
    IFS="$ORIG_IFS"
    
    # Pick first zone as primary (could randomize later)
    PRIMARY_ZONE="${ZONE_ARRAY[0]}"
    
    if [[ -z "${ZONE_COORDS[$PRIMARY_ZONE]:-}" ]]; then
        continue
    fi
    
    # Parse coordinates - restore IFS after read
    IFS=',' read -r MAP X Y Z O <<< "${ZONE_COORDS[$PRIMARY_ZONE]}"
    IFS="$ORIG_IFS"
    
    # Generate UPDATE for each race
    for RACE in 1 2 3 4 5 6 7 8 10 11; do
        # For levels 1-12, use race-specific starter zones
        if [[ $LEVEL -le 12 ]]; then
            ZONE="${RACE_ZONES[$RACE]}"
            
            # Use zone-specific coordinates if available
            if [[ -n "${ZONE_COORDS[$ZONE]:-}" ]]; then
                IFS=',' read -r MAP X Y Z O <<< "${ZONE_COORDS[$ZONE]}"
                IFS="$ORIG_IFS"
            else
                continue
            fi
        else
            ZONE="$PRIMARY_ZONE"
        fi
        
        # Generate UPDATE statement using printf (safer than heredoc)
        printf "UPDATE acore_characters.characters c\nINNER JOIN acore_playerbots.playerbots_random_bots b ON c.guid = b.bot\nSET c.map = %s, c.position_x = %s, c.position_y = %s, c.position_z = %s, c.orientation = %s, c.zone = %s\nWHERE c.level = %s AND c.race = %s AND b.bot > 0;\n\n" "$MAP" "$X" "$Y" "$Z" "$O" "$ZONE" "$LEVEL" "$RACE" >> "$SQL_FILE"
        ((TOTAL_UPDATES++))
    done
done

echo ""
echo "Generated $TOTAL_UPDATES UPDATE statements"
echo "SQL file: $SQL_FILE"

# Show pre-relocation stats
echo ""
echo "Pre-relocation bot distribution:"
$MYSQL_CMD -e "SELECT COUNT(*) as bot_count FROM acore_playerbots.playerbots_random_bots WHERE bot > 0;" 2>/dev/null || echo "⚠️  Could not query bot count"

# Execute SQL
echo ""
echo "Executing relocations..."
$MYSQL_CMD < "$SQL_FILE" 2>&1 | grep -v "Warning: Using a password on the command line" || true

echo ""
echo "✅ Bot relocation complete!"
echo ""
echo "Verification: Check zone distribution"
$MYSQL_CMD -e "
SELECT c.zone, COUNT(*) as bots 
FROM acore_characters.characters c
INNER JOIN acore_playerbots.playerbots_random_bots b ON c.guid = b.bot
WHERE b.bot > 0
GROUP BY c.zone 
ORDER BY bots DESC 
LIMIT 20;
" 2>/dev/null || echo "⚠️  Could not verify distribution"
