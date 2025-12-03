# AzerothCore Automated Update System

This document describes the automated update system for keeping AzerothCore core and modules up to date.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Scheduling](#scheduling)
- [Notifications](#notifications)
- [Logs](#logs)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

The `update-azerothcore.sh` script automates the process of:

1. **Updating the AzerothCore core** (Playerbot branch)
2. **Updating all 6 submodules** to their latest versions
3. **Rebuilding Docker containers** (optional)
4. **Sending status notifications** to Uptime Kuma → Discord
5. **Managing logs** with automatic cleanup (90-day retention)

### Components

| Component                             | Purpose               | Location                        |
| ------------------------------------- | --------------------- | ------------------------------- |
| `update-azerothcore.sh`               | Main update script    | `/root/azerothcore-wotlk/`      |
| `.notification-config`                | Notification settings | `/root/azerothcore-wotlk/`      |
| `.notification-config.template`       | Config template       | `/root/azerothcore-wotlk/`      |
| `logs/`                               | Log directory         | `/root/logs/` |
| `README-TrueNAS-Scale-Updates.md`     | This file             | `/root/azerothcore-wotlk/`      |
| `README-TrueNAS-Scale-Uptime-Kuma.md` | Uptime Kuma guide     | `/root/azerothcore-wotlk/`      |

---

## 🚀 Quick Start

### 1. Configure Notifications

```bash
cd ~/azerothcore-wotlk

# Copy the template
cp .notification-config.template .notification-config

# Edit and add your Uptime Kuma push URL
vim .notification-config
# Press 'i' for insert mode, edit, then ESC and :wq to save
```

See [README-TrueNAS-Scale-Uptime-Kuma.md](README-TrueNAS-Scale-Uptime-Kuma.md) for detailed instructions.

### 2. Test the Script

```bash
# Dry run (preview what would be updated)
./update-azerothcore.sh --dry-run

# Git updates only (no rebuild)
./update-azerothcore.sh --git-only

# Full update with rebuild
./update-azerothcore.sh
```

### 3. Set Up Automated Scheduling

```bash
# Edit crontab
crontab -e

# Add these lines:
# Daily git updates at 4:15 PM EST
15 16 * * * /root/azerothcore-wotlk/update-azerothcore.sh --git-only >> /var/log/azerothcore-daily.log 2>&1

# Weekly full rebuild on Sunday at 9:00 AM EST
0 9 * * 0 /root/azerothcore-wotlk/update-azerothcore.sh >> /var/log/azerothcore-weekly.log 2>&1
```

---

## 📖 Usage

### Command Line Options

```bash
./update-azerothcore.sh [OPTIONS]
```

| Option         | Description                                               |
| -------------- | --------------------------------------------------------- |
| _(no options)_ | **Default:** Update Git repos + rebuild Docker containers |
| `--git-only`   | Update Git repositories only, skip Docker rebuild         |
| `--dry-run`    | Preview what would be updated without making changes      |
| `--help`       | Show help message                                         |

### Examples

#### Full Update (Default)

```bash
./update-azerothcore.sh
```

- ✅ Updates core repository
- ✅ Updates all 6 modules
- ✅ Rebuilds Docker containers
- ⏱️ Duration: ~15-30 minutes (depends on changes)
- 📨 Sends notification to Uptime Kuma

#### Git-Only Mode

```bash
./update-azerothcore.sh --git-only
```

- ✅ Updates core repository
- ✅ Updates all 6 modules
- ❌ Skips Docker rebuild
- ⏱️ Duration: ~1-2 minutes
- 📨 Sends notification to Uptime Kuma

**Use case:** Daily checks for updates without the overhead of rebuilding

#### Dry Run Mode

```bash
./update-azerothcore.sh --dry-run
```

- 🔍 Shows what updates are available
- ❌ Doesn't actually update anything
- ❌ Doesn't rebuild Docker
- ⏱️ Duration: ~30 seconds
- ❌ No notifications sent

**Use case:** Preview updates before applying them

---

## ⏰ Scheduling

### Recommended Schedule

The system is configured with a two-tier approach:

#### Daily Updates (Git-Only)

- **Time:** 4:15 PM EST (16:15)
- **Command:** `update-azerothcore.sh --git-only`
- **Purpose:** Keep repositories up to date without rebuild overhead
- **Duration:** 1-2 minutes
- **Impact:** Zero downtime

#### Weekly Rebuild

- **Time:** Sunday 9:00 AM EST (09:00)
- **Command:** `update-azerothcore.sh`
- **Purpose:** Full rebuild with all updates
- **Duration:** 15-30 minutes
- **Impact:** Minimal (Docker hot-reloads)

### Cron Configuration

```bash
# Edit root's crontab
crontab -e
```

Add these lines:

```cron
# AzerothCore Daily Git Updates (no rebuild) - 4:15 PM EST
15 16 * * * /root/azerothcore-wotlk/update-azerothcore.sh --git-only >> /var/log/azerothcore-daily.log 2>&1

# AzerothCore Weekly Full Update + Rebuild - Sunday 9:00 AM EST
0 9 * * 0 /root/azerothcore-wotlk/update-azerothcore.sh >> /var/log/azerothcore-weekly.log 2>&1
```

### Verify Cron Jobs

```bash
# List current crontab
crontab -l

# Check cron logs
tail -f /var/log/cron
```

### Alternative Schedules

#### More Frequent Updates

```cron
# Every 6 hours (git-only)
0 */6 * * * /root/azerothcore-wotlk/update-azerothcore.sh --git-only

# Twice weekly rebuild (Wednesday + Sunday)
0 9 * * 0,3 /root/azerothcore-wotlk/update-azerothcore.sh
```

#### Less Frequent Updates

```cron
# Weekly git updates (Sunday 4:15 PM)
15 16 * * 0 /root/azerothcore-wotlk/update-azerothcore.sh --git-only

# Monthly rebuild (1st of month, 9 AM)
0 9 1 * * /root/azerothcore-wotlk/update-azerothcore.sh
```

---

## 🔔 Notifications

### Notification Flow

```
Script → Uptime Kuma → Discord
```

The script sends status updates to **Uptime Kuma** using push monitors.
Uptime Kuma then forwards notifications to **Discord** (and any other configured channels).

### Configuration

Edit `/root/azerothcore-wotlk/.notification-config`:

```bash
# Enable/Disable notifications
ENABLE_UPTIMEKUMA=true

# Your Uptime Kuma push URL
UPTIMEKUMA_PUSH_URL="http://192.168.144.3:3001/api/push/YOUR_KEY"
```

See [UPTIMEKUMA-SETUP.md](UPTIMEKUMA-SETUP.md) for step-by-step setup instructions.

### Notification Types

#### Success (Status: UP)

- ✅ Update completed successfully
- Includes: Duration, updated repositories, mode (full/git-only)

#### No Updates (Status: UP)

- ℹ️ All repositories already up to date
- Includes: Duration

#### Blocked (Status: DOWN)

- ⚠️ Local changes detected
- **Action required:** Commit or stash changes before updating

#### Failed (Status: DOWN)

- ❌ Update or rebuild failed
- Includes: Error message, log file location

#### Timeout (Status: DOWN)

- ⏱️ Docker rebuild exceeded 60-minute timeout
- **Action required:** Check build logs for issues

---

## 📝 Logs

### Log Locations

| Log Type        | Location                                              | Purpose                          |
| --------------- | ----------------------------------------------------- | -------------------------------- |
| **Update Logs** | `~/logs/update_YYYYMMDD_HHMMSS.log` | Detailed script execution log    |
| **Build Logs**  | `~/logs/build_YYYYMMDD_HHMMSS.log`  | Docker build output (if rebuild) |
| **Daily Cron**  | `/var/log/azerothcore-daily.log`                      | Daily git-only runs              |
| **Weekly Cron** | `/var/log/azerothcore-weekly.log`                     | Weekly full rebuilds             |

### Viewing Logs

#### Latest Update Log

```bash
cd ~/logs
ls -t update_*.log | head -1 | xargs tail -f
```

#### Latest Build Log

```bash
cd ~/logs
ls -t build_*.log | head -1 | xargs tail -f
```

#### Cron Logs

```bash
# Daily updates
tail -f /var/log/azerothcore-daily.log

# Weekly rebuilds
tail -f /var/log/azerothcore-weekly.log
```

### Log Retention

- **Automatic cleanup:** Logs older than 90 days are automatically deleted
- **Manual cleanup:**
    ```bash
    cd ~/logs
    find . -name "*.log" -mtime +90 -delete
    ```

### Log Format

Each log entry includes:

- Timestamp (YYYY-MM-DD HH:MM:SS)
- Level (INFO/SUCCESS/WARNING/ERROR)
- Message

Example:

```
[2025-12-02 16:15:00] [INFO] Starting AzerothCore update...
[2025-12-02 16:15:05] [SUCCESS] Core repository updated successfully
[2025-12-02 16:15:10] [SUCCESS] All submodules updated successfully
[2025-12-02 16:16:45] [SUCCESS] Update completed in 1m 45s
```

---

## 🔧 Troubleshooting

### Common Issues

#### Issue: "Local changes detected"

**Symptom:** Script exits with error, notification sent

**Cause:** You have uncommitted changes in the repository

**Solution:**

```bash
cd ~/azerothcore-wotlk

# View changes
git status

# Option 1: Commit changes
git add .
git commit -m "Your commit message"

# Option 2: Stash changes
git stash

# Then run update again
./update-azerothcore.sh
```

---

#### Issue: "Notifications not working"

**Symptom:** Script runs but no notifications received

**Solution:**

1. Check if `.notification-config` exists:

    ```bash
    ls -la ~/azerothcore-wotlk/.notification-config
    ```

2. Verify push URL is set:

    ```bash
    grep UPTIMEKUMA_PUSH_URL ~/azerothcore-wotlk/.notification-config
    ```

3. Test push URL manually:

    ```bash
    curl "YOUR_PUSH_URL?status=up&msg=test"
    ```

4. Check Uptime Kuma dashboard

---

#### Issue: "Docker rebuild timeout"

**Symptom:** Build exceeds 60 minutes and is terminated

**Cause:** Build is taking too long (large changes, slow system)

**Solution:**

1. Check build log for issues:

    ```bash
    cd ~/logs
    ls -t build_*.log | head -1 | xargs tail -100
    ```

2. Check for compilation errors

3. Try manual rebuild:
    ```bash
    cd ~/azerothcore-wotlk
    docker compose up -d --build
    ```

---

#### Issue: "Submodule update failed"

**Symptom:** Error during submodule update

**Cause:** Network issues, repository conflicts, or module deleted

**Solution:**

1. Check network connectivity:

    ```bash
    ping -c 3 github.com
    ```

2. Manually update problematic submodule:

    ```bash
    cd ~/azerothcore-wotlk/modules/mod-PROBLEM-MODULE
    git fetch origin
    git pull origin master
    ```

3. Reinitialize submodules:
    ```bash
    cd ~/azerothcore-wotlk
    git submodule sync
    git submodule update --init --recursive
    ```

---

#### Issue: "Cron job not running"

**Symptom:** No updates happening at scheduled times

**Solution:**

1. Verify cron service is running:

    ```bash
    systemctl status cron
    ```

2. Check crontab entries:

    ```bash
    crontab -l
    ```

3. Check cron logs:

    ```bash
    tail -f /var/log/cron
    ```

4. Test script manually:

    ```bash
    /root/azerothcore-wotlk/update-azerothcore.sh --dry-run
    ```

5. Verify script permissions:
    ```bash
    ls -la /root/azerothcore-wotlk/update-azerothcore.sh
    # Should show: -rwxr-xr-x (executable)
    ```

---

### Getting Help

If you encounter issues not covered here:

1. **Check the logs:**

    ```bash
    cd ~/logs
    ls -lt | head -5  # List recent logs
    ```

2. **Run in dry-run mode:**

    ```bash
    ./update-azerothcore.sh --dry-run
    ```

3. **Test notifications:**

    ```bash
    curl "YOUR_PUSH_URL?status=up&msg=test"
    ```

4. **Check system resources:**
    ```bash
    df -h  # Disk space
    free -h  # Memory
    docker ps  # Running containers
    ```

---

## 📚 Related Documentation

- [UPTIMEKUMA-SETUP.md](UPTIMEKUMA-SETUP.md) - Uptime Kuma configuration guide
- [AzerothCore Installation Guide](https://www.azerothcore.org/wiki/installation)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

## 🔄 Update History

| Date       | Version | Changes         |
| ---------- | ------- | --------------- |
| 2025-12-02 | 1.0.0   | Initial release |

---

**Last Updated:** 2025-12-02
