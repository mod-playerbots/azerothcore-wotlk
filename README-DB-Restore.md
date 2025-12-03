# Cron Setup Instructions for Database Sync

This document explains how to set up the automated sync from the live azerothcore-wotlk server to the testing-azerothcore-wotlk server.

## Files Created

1. **restore_to_testing.sh** - Main restore script that syncs databases
2. **This document** - Setup instructions

## Prerequisites

1. Both azerothcore-wotlk and testing-azerothcore-wotlk servers should be running
2. The backup script (`mysqlbackup.sh`) should be running regularly on the live server
3. Backups are stored in `/FastStorage/Shared/Azerothcore`

## Installation Steps

### 1. Make the restore script executable

```bash
chmod +x /Users/havoc/azerothcore/restore_to_testing.sh
```

### 2. Test the script manually

```bash
/Users/havoc/azerothcore/restore_to_testing.sh
```

Check the log files in `/FastStorage/Shared/Azerothcore/logs/` to verify it worked correctly.

### 3. Set up the cron job

Edit your crontab:

```bash
crontab -e
```

Add one of the following lines depending on your preferred sync schedule:

#### Option A: Sync daily at 3 AM

```
0 3 * * * /Users/havoc/azerothcore/restore_to_testing.sh >> /FastStorage/Shared/Azerothcore/logs/cron.log 2>&1
```

#### Option B: Sync every 6 hours

```
0 */6 * * * /Users/havoc/azerothcore/restore_to_testing.sh >> /FastStorage/Shared/Azerothcore/logs/cron.log 2>&1
```

#### Option C: Sync every 12 hours (at 2 AM and 2 PM)

```
0 2,14 * * * /Users/havoc/azerothcore/restore_to_testing.sh >> /FastStorage/Shared/Azerothcore/logs/cron.log 2>&1
```

#### Option D: Sync weekly on Sunday at 2 AM

```
0 2 * * 0 /Users/havoc/azerothcore/restore_to_testing.sh >> /FastStorage/Shared/Azerothcore/logs/cron.log 2>&1
```

### 4. Verify cron job is scheduled

```bash
crontab -l
```

## What Gets Synced

The script syncs the following databases from live to testing:

- **acore_auth** - Player accounts (usernames, passwords, etc.)
- **acore_characters** - Character data (characters, inventory, etc.)

The `acore_world` database is NOT synced as it contains server configuration and world data that should be managed separately.

## Logs

- Main restore logs: `/FastStorage/Shared/Azerothcore/logs/restore_YYYYMMDD_HHMMSS.log`
- Cron output: `/FastStorage/Shared/Azerothcore/logs/cron.log`

## Monitoring

To monitor the sync operations:

```bash
# View the latest restore log
ls -t /FastStorage/Shared/Azerothcore/logs/restore_*.log | head -n 1 | xargs tail -f

# View cron log
tail -f /FastStorage/Shared/Azerothcore/logs/cron.log
```

## Troubleshooting

### Script fails with "Testing database container not found"

Ensure the testing server is running:

```bash
cd /Users/havoc/azerothcore/testing-azerothcore-wotlk
docker compose ps
```

If not running, start it:

```bash
docker compose up -d
```

### No backups found

Ensure the backup script is running on the live server:

```bash
cd /Users/havoc/azerothcore/azerothcore-wotlk
./mysqlbackup.sh
```

Check that backups exist:

```bash
ls -lh /FastStorage/Shared/Azerothcore/*.sql
```

### Permission denied

Make sure the script is executable:

```bash
chmod +x /Users/havoc/azerothcore/restore_to_testing.sh
```

## Backup Retention

The script uses the most recent backup for each database. To implement backup retention and cleanup:

```bash
# Add to backup script to keep only last 7 days of backups
find /FastStorage/Shared/Azerothcore -name "*.sql" -type f -mtime +7 -delete
```

## Notes

- The script automatically drops and recreates the databases in the testing environment
- All data in testing's auth and characters databases will be replaced
- The testing world server may need to be restarted after the sync for changes to take effect
- Consider scheduling the sync during low-activity periods
