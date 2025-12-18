#!/bin/bash

# Dynamic Bot Relocation Script Generator
# Reads ZoneBrackets from playerbots.conf and generates relocation SQL

set -e

echo "Generating dynamic bot relocation SQL from playerbots.conf..."

# Get playerbots.conf from worldserver container
CONF_FILE="/tmp/playerbots_temp.conf"
docker cp testing-ac-worldserver:/azerothcore/env/dist/etc/modules/playerbots.conf "$CONF_FILE" 2>/dev/null || {
    echo "ERROR: Could not access playerbots.conf from worldserver container"
    exit 1
}

# Define zone coordinates mapping (these remain static)
declare -A ZONE_COORDS

# Starting zones (1-12)
ZONE_COORDS[12]="-8949.95,-132.49,83.53,0,12"      # Northshire (Elwynn Forest)
ZONE_COORDS[1]="-6240.32,331.03,382.76,0,1"        # Coldridge Valley (Dun Morogh)
ZONE_COORDS[141]="10311.30,832.46,1326.41,1,141"   # Shadowglen (Teldrassil)
ZONE_COORDS[3524]="-3961.67,-13931.20,100.62,530,3524" # Ammen Vale (Azuremyst)
ZONE_COORDS[14]="-618.52,-4251.70,38.72,1,14"      # Valley of Trials (Durotar)
ZONE_COORDS[85]="1676.72,1678.08,121.67,0,85"      # Deathknell (Tirisfal)
ZONE_COORDS[215]="-2917.58,-257.98,52.97,1,215"    # Camp Narache (Mulgore)
ZONE_COORDS[3430]="10349.60,-6357.29,33.13,530,3430" # Sunstrider Isle (Eversong)

# Low level towns (10-19)
ZONE_COORDS[40]="-10628.69,1055.96,36.24,0,40"     # Westfall
ZONE_COORDS[38]="-5420.52,-2894.23,347.57,0,38"    # Loch Modan
ZONE_COORDS[148]="6463.25,683.24,8.92,1,148"       # Darkshore
ZONE_COORDS[130]="508.94,1483.69,124.43,0,130"     # Silverpine
ZONE_COORDS[17]="-450.95,-2643.28,96.23,1,17"      # Barrens
ZONE_COORDS[3433]="7595.73,-6795.31,84.45,530,3433" # Ghostlands

# Capital cities (20-60)
ZONE_COORDS[1519]="-8833.38,628.63,94.00,0,1519"   # Stormwind
ZONE_COORDS[1537]="-4918.88,-940.41,501.56,0,1537" # Ironforge
ZONE_COORDS[1657]="9951.52,2280.45,1341.39,1,1657" # Darnassus
ZONE_COORDS[1637]="1569.59,-4397.63,16.06,1,1637"  # Orgrimmar
ZONE_COORDS[1497]="1633.75,240.08,-43.10,0,1497"   # Undercity
ZONE_COORDS[1638]="-1278.62,122.91,131.35,1,1638"  # Thunder Bluff

# TBC zones (61-70)
ZONE_COORDS[3703]="-1838.16,5301.79,-12.43,530,3703" # Shattrath
ZONE_COORDS[3483]="-207.32,2035.91,96.77,530,3483"  # Hellfire Peninsula

# WotLK zones (71-80)
ZONE_COORDS[4395]="5804.15,624.77,647.77,571,4395"  # Dalaran
ZONE_COORDS[3537]="2438.81,-5630.17,420.64,571,3537" # Borean Tundra
ZONE_COORDS[495]="1951.89,-6374.13,162.50,571,495"  # Howling Fjord

# Parse ZoneBrackets from playerbots.conf
declare -A ZONE_BRACKETS
while IFS= read -r line; do
    if [[ $line =~ ^AiPlayerbot\.ZoneBracket\.([0-9]+)[[:space:]]*=[[:space:]]*([0-9]+),([0-9]+) ]]; then
        zone_id="${BASH_REMATCH[1]}"
        min_level="${BASH_REMATCH[2]}"
        max_level="${BASH_REMATCH[3]}"
        ZONE_BRACKETS[$zone_id]="$min_level,$max_level"
    fi
done < "$CONF_FILE"

echo "Parsed ${#ZONE_BRACKETS[@]} zone brackets from playerbots.conf"

# Start generating SQL
SQL_FILE="/tmp/generated_relocate.sql"
cat > "$SQL_FILE" << 'EOF'
-- Dynamically Generated Bot Relocation Script
-- Generated from playerbots.conf ZoneBrackets
-- This ensures bots are ALWAYS in sync with ZoneBracket definitions

USE acore_characters;

-- Force ALL bots offline before any relocation
UPDATE characters 
SET online = 0 
WHERE account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

START TRANSACTION;

EOF

# Generate SQL for each zone with known coordinates
for zone_id in "${!ZONE_COORDS[@]}"; do
    if [[ -n "${ZONE_BRACKETS[$zone_id]}" ]]; then
        IFS=',' read -r min_level max_level <<< "${ZONE_BRACKETS[$zone_id]}"
        IFS=',' read -r pos_x pos_y pos_z map zone <<< "${ZONE_COORDS[$zone_id]}"
        
        # Determine race filter based on zone
        race_filter=""
        if [[ $zone_id =~ ^(12|1|141|3524|40|38|148|1519|1537|1657)$ ]]; then
            race_filter="AND race IN (1, 3, 4, 7, 11)"  # Alliance
        elif [[ $zone_id =~ ^(14|85|215|3430|130|17|3433|1637|1497|1638)$ ]]; then
            race_filter="AND race IN (2, 5, 6, 8, 10)"  # Horde
        fi
        
        # Generate UPDATE statement
        cat >> "$SQL_FILE" << SQL_BLOCK

-- Zone $zone_id: Levels $min_level-$max_level
UPDATE characters 
SET 
    position_x = $pos_x,
    position_y = $pos_y,
    position_z = $pos_z,
    map = $map,
    zone = $zone,
    orientation = 0
WHERE level BETWEEN $min_level AND $max_level
  $race_filter
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

SQL_BLOCK
    fi
done

# Add commit and report
cat >> "$SQL_FILE" << 'EOF'

COMMIT;

-- Report results
SELECT 'Bot Relocation Complete - All bots placed in level-appropriate zones (from playerbots.conf)' as status, 
       NOW() as timestamp,
       COUNT(*) as total_bots_relocated 
FROM characters 
WHERE account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');
EOF

echo "Generated SQL with $(grep -c '^UPDATE characters' $SQL_FILE) relocation statements"

# Execute the generated SQL
mysql -h testing-ac-database -uroot -p$MYSQL_ROOT_PASSWORD < "$SQL_FILE"

# Cleanup
rm -f "$CONF_FILE" "$SQL_FILE"

echo "Bot relocation complete!"
