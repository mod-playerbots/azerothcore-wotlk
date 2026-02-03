#!/bin/bash
MYSQL_ROOT_PASSWORD="password" #LOL who cares.

MYSQL_CONTAINER_NAME="ac-database"

DATABASES=("acore_auth" "acore_characters" "acore_world")

BACKUP_DIR="/FastStorage/Shared/Azerothcore"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

for DB in "${DATABASES[@]}"
do
    docker exec -i $MYSQL_CONTAINER_NAME mysqldump -u root -p$MYSQL_ROOT_PASSWORD $DB > "$BACKUP_DIR/$DB-$TIMESTAMP.sql"
    echo "Backup of $DB completed at $(date)"
done
