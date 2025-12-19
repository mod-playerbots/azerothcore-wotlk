#!/bin/bash
#
# Restore Script: Sync databases from azerothcore-wotlk (live) to testing-azerothcore-wotlk
#
# This script restores auth, characters, and world databases from production backups,
# then automatically renames all RNDBOT accounts to TESTRNDBOT accounts to avoid
# recreating thousands of bot characters from scratch.
#

set -e # Exit on error

# Configuration
BACKUP_DIR="/FastStorage/Shared/Azerothcore"
LOG_DIR="/FastStorage/Shared/Azerothcore/logs"
LOG_FILE="$LOG_DIR/restore_$(date +%Y%m%d_%H%M%S).log"

# Testing server details
TESTING_PROJECT_DIR="/root/testing-azerothcore-wotlk"
TESTING_CONTAINER="testing-ac-database"

# Database credentials
MYSQL_ROOT_PASSWORD="password"

# Databases to sync
DATABASES=("acore_auth" "acore_characters" "acore_world")

# Create log directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Starting database restore to testing environment"
log "========================================="

# Function to find the latest backup
find_latest_backup() {
	local db_name=$1
	local latest_backup=$(ls -t "$BACKUP_DIR/${db_name}"-*.sql 2>/dev/null | head -n 1)

	if [ -z "$latest_backup" ]; then
		log "ERROR: No backup found for database $db_name"
		return 1
	fi

	echo "$latest_backup"
}

# Function to get testing database container name
get_testing_container() {
	local container_name=""

	if docker ps -q -f name=testing-azerothcore-wotlk-ac-database-1 2>/dev/null | grep -q .; then
		container_name="testing-azerothcore-wotlk-ac-database-1"
	elif docker ps -q -f name=testing-azerothcore-wotlk_ac-database_1 2>/dev/null | grep -q .; then
		container_name="testing-azerothcore-wotlk_ac-database_1"
	elif docker ps -q -f name=testing-ac-database 2>/dev/null | grep -q .; then
		container_name="testing-ac-database"
	else
		log "ERROR: Testing database container not found"
		return 1
	fi

	echo "$container_name"
}

# Check if testing environment is running
log "Checking testing environment status..."
cd "$TESTING_PROJECT_DIR"

TESTING_CONTAINER=$(get_testing_container)
if [ $? -ne 0 ]; then
	log "ERROR: Could not find testing database container"
	exit 1
fi

log "Found testing database container: $TESTING_CONTAINER"

# Restore each database
for DB in "${DATABASES[@]}"; do
	log "----------------------------------------"
	log "Processing database: $DB"

	BACKUP_FILE=$(find_latest_backup "$DB")
	if [ $? -ne 0 ]; then
		log "Skipping $DB due to missing backup"
		continue
	fi

	log "Found backup: $BACKUP_FILE"
	BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
	log "Backup size: $BACKUP_SIZE"

	log "Dropping existing database $DB..."
	docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS $DB;" 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"

	log "Creating fresh database $DB..."
	docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DB;" 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"

	log "Restoring $DB from backup..."
	START_TIME=$(date +%s)

	cat "$BACKUP_FILE" | docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"

	END_TIME=$(date +%s)
	DURATION=$((END_TIME - START_TIME))

	if [ $? -eq 0 ]; then
		log "SUCCESS: Restored $DB in ${DURATION} seconds"
	else
		log "ERROR: Failed to restore $DB"
		exit 1
	fi
done

log "========================================="
log "Running post-restore transformations..."
log "========================================="

# Step 1: Delete any old TESTRNDBOT accounts (210006-210289 range from previous setup)
log "Step 1: Cleaning up old TESTRNDBOT accounts from previous setup..."

docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" << 'SQL_EOF' 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"
SET FOREIGN_KEY_CHECKS=0;

-- Delete old TESTRNDBOT account range (210006-210289) and their characters
DELETE FROM acore_characters.characters WHERE account BETWEEN 210006 AND 210289;
DELETE FROM acore_characters.character_achievement WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);
DELETE FROM acore_characters.character_action WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);
DELETE FROM acore_characters.character_inventory WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);
DELETE FROM acore_auth.realmcharacters WHERE acctid BETWEEN 210006 AND 210289;
DELETE FROM acore_auth.account WHERE id BETWEEN 210006 AND 210289;

SELECT CONCAT('Deleted old TESTRNDBOT accounts (210006-210289): ', ROW_COUNT(), ' accounts') as status;

SET FOREIGN_KEY_CHECKS=1;
SQL_EOF

if [ $? -ne 0 ]; then
	log "ERROR: Failed to clean up old TESTRNDBOT accounts"
	exit 1
fi

log "SUCCESS: Old TESTRNDBOT accounts cleaned up"

# Step 2: Rename RNDBOT accounts to TESTRNDBOT
log "Step 2: Renaming RNDBOT accounts to TESTRNDBOT..."

docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" << 'SQL_EOF' 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"
USE acore_auth;

SET FOREIGN_KEY_CHECKS=0;

SELECT 'Before transformation:' as status;
SELECT 
    COUNT(*) as total_accounts,
    SUM(CASE WHEN UPPER(username) LIKE 'RNDBOT%' THEN 1 ELSE 0 END) as rndbot_count,
    SUM(CASE WHEN UPPER(username) LIKE 'TESTRNDBOT%' THEN 1 ELSE 0 END) as testrndbot_count
FROM account;

-- Rename RNDBOT to TESTRNDBOT
UPDATE account 
SET username = CONCAT('TESTRNDBOT', SUBSTRING(username, 7))
WHERE UPPER(username) LIKE 'RNDBOT%';

SELECT 'After transformation:' as status;
SELECT 
    COUNT(*) as total_accounts,
    SUM(CASE WHEN UPPER(username) LIKE 'RNDBOT%' THEN 1 ELSE 0 END) as rndbot_count,
    SUM(CASE WHEN UPPER(username) LIKE 'TESTRNDBOT%' THEN 1 ELSE 0 END) as testrndbot_count
FROM account;

SET FOREIGN_KEY_CHECKS=1;
SQL_EOF

if [ $? -ne 0 ]; then
	log "ERROR: Failed to rename RNDBOT accounts"
	exit 1
fi

log "SUCCESS: RNDBOT accounts renamed to TESTRNDBOT"

# Step 3: Register all accounts to realm 2 (testing realm)
log "Step 3: Registering all accounts to realm 2..."

docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" << 'SQL_EOF' 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"
USE acore_auth;

SET FOREIGN_KEY_CHECKS=0;

-- Clear all existing realm registrations for realm 2
DELETE FROM realmcharacters WHERE realmid = 2;

-- Register all accounts (bot and player) to realm 2
INSERT INTO realmcharacters (acctid, realmid, numchars)
SELECT 
    c.account as acctid,
    2 as realmid,
    COUNT(*) as numchars
FROM acore_characters.characters c
INNER JOIN account a ON c.account = a.id
GROUP BY c.account;

SELECT 'Realm registrations for realm 2:' as status;
SELECT 
    COUNT(DISTINCT acctid) as registered_accounts,
    SUM(numchars) as total_characters
FROM realmcharacters
WHERE realmid = 2;

SET FOREIGN_KEY_CHECKS=1;
SQL_EOF

if [ $? -ne 0 ]; then
	log "ERROR: Failed to register accounts to realm 2"
	exit 1
fi

log "SUCCESS: All accounts registered to realm 2"

# Step 4: Clean up orphaned characters
log "Step 4: Cleaning up orphaned characters..."

docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" << 'SQL_EOF' 2>&1 | grep -v "Warning" | tee -a "$LOG_FILE"
SET FOREIGN_KEY_CHECKS=0;

-- Delete orphaned characters (no matching account)
DELETE FROM acore_characters.characters
WHERE account NOT IN (SELECT id FROM acore_auth.account);

-- Clean up orphaned character data
DELETE FROM acore_characters.character_achievement  
WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);

DELETE FROM acore_characters.character_action
WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);

DELETE FROM acore_characters.character_inventory
WHERE guid NOT IN (SELECT guid FROM acore_characters.characters);

SELECT 'Final character count:' as status;
SELECT COUNT(*) as total_characters FROM acore_characters.characters;

SET FOREIGN_KEY_CHECKS=1;
SQL_EOF

if [ $? -ne 0 ]; then
	log "ERROR: Failed to clean up orphaned characters"
	exit 1
fi

log "SUCCESS: Orphaned characters cleaned up"

log "========================================="
log "Database restore completed successfully"
log "========================================="

# Display summary
log ""
log "Summary of restored databases:"
for DB in "${DATABASES[@]}"; do
	BACKUP_FILE=$(find_latest_backup "$DB")
	BACKUP_DATE=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$BACKUP_FILE" 2>/dev/null || stat -c "%y" "$BACKUP_FILE" 2>/dev/null | cut -d'.' -f1)
	log "  - $DB: Restored from backup dated $BACKUP_DATE"
done

log ""
log "Post-restore transformations completed:"
log "  - Old TESTRNDBOT accounts (210006-210289) deleted"
log "  - All RNDBOT accounts renamed to TESTRNDBOT"
log "  - All accounts registered to testing realm (realmid = 2)"
log "  - Orphaned characters cleaned up"

log ""
log "========================================="
log "Rebuilding containers to apply changes"
log "========================================="

# Stop containers
log "Stopping containers..."
cd "$TESTING_PROJECT_DIR"
docker compose stop 2>&1 | tee -a "$LOG_FILE"

if [ $? -ne 0 ]; then
	log "ERROR: Failed to stop containers"
	exit 1
fi

# Start containers
log "Starting containers..."
docker compose up -d 2>&1 | tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
	log "SUCCESS: Containers restarted"
else
	log "ERROR: Failed to restart containers"
	exit 1
fi

log ""
log "========================================="
log "Restore and rebuild completed successfully"
log "========================================="
log "Log file: $LOG_FILE"
