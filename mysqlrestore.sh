#!/bin/bash
#
# Restore Script: Sync databases from azerothcore-wotlk (live) to testing-azerothcore-wotlk
#
# This script finds the latest backups and restores the auth and characters databases
# to the testing environment, keeping player accounts and characters in sync.
#

set -e # Exit on error

# Configuration
BACKUP_DIR="/FastStorage/Shared/Azerothcore"
LOG_DIR="/FastStorage/Shared/Azerothcore/logs"
LOG_FILE="$LOG_DIR/restore_$(date +%Y%m%d_%H%M%S).log"

# Live server container (where backups come from)
LIVE_CONTAINER="ac-database"

# Testing server details
TESTING_PROJECT_DIR="/Users/havoc/azerothcore/testing-azerothcore-wotlk"
TESTING_CONTAINER="testing-ac-database" # Will be prefixed by compose

# Database credentials (from docker-compose)
MYSQL_ROOT_PASSWORD="password"

# Databases to sync (auth for accounts, characters for character data)
DATABASES=("acore_auth" "acore_characters")

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Logging function
log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Starting database restore to testing environment"
log "========================================="

# Function to find the latest backup for a database
find_latest_backup() {
	local db_name=$1
	local latest_backup=$(ls -t "$BACKUP_DIR/${db_name}"-*.sql 2>/dev/null | head -n 1)

	if [ -z "$latest_backup" ]; then
		log "ERROR: No backup found for database $db_name in $BACKUP_DIR"
		return 1
	fi

	echo "$latest_backup"
}

# Function to get testing database container name
get_testing_container() {
	# Try different possible container names
	local container_name=""

	# Check if using testing-azerothcore-wotlk prefix
	if docker ps -q -f name=testing-azerothcore-wotlk-ac-database-1 2>/dev/null | grep -q .; then
		container_name="testing-azerothcore-wotlk-ac-database-1"
	elif docker ps -q -f name=testing-azerothcore-wotlk_ac-database_1 2>/dev/null | grep -q .; then
		container_name="testing-azerothcore-wotlk_ac-database_1"
	elif docker ps -q -f name=testing-ac-database 2>/dev/null | grep -q .; then
		container_name="testing-ac-database"
	else
		log "ERROR: Testing database container not found. Please ensure testing-azerothcore-wotlk is running."
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

	# Find latest backup
	BACKUP_FILE=$(find_latest_backup "$DB")
	if [ $? -ne 0 ]; then
		log "Skipping $DB due to missing backup"
		continue
	fi

	log "Found backup: $BACKUP_FILE"
	BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
	log "Backup size: $BACKUP_SIZE"

	# Drop and recreate database in testing environment
	log "Dropping existing database $DB in testing environment..."
	docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS $DB;" 2>&1 | tee -a "$LOG_FILE"

	log "Creating fresh database $DB..."
	docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DB;" 2>&1 | tee -a "$LOG_FILE"

	# Restore backup
	log "Restoring $DB from backup..."
	START_TIME=$(date +%s)

	cat "$BACKUP_FILE" | docker exec -i "$TESTING_CONTAINER" mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" 2>&1 | tee -a "$LOG_FILE"

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
log "Database restore completed successfully"
log "========================================="
log "Log file: $LOG_FILE"

# Display summary
log ""
log "Summary of restored databases:"
for DB in "${DATABASES[@]}"; do
	BACKUP_FILE=$(find_latest_backup "$DB")
	BACKUP_DATE=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$BACKUP_FILE" 2>/dev/null || stat -c "%y" "$BACKUP_FILE" 2>/dev/null | cut -d'.' -f1)
	log "  - $DB: Restored from backup dated $BACKUP_DATE"
done

log ""
log "Player accounts and characters are now synced with live server"
