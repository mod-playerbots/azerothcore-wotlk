# Uptime Kuma Setup Guide for AzerothCore Updates

This guide explains how to set up Uptime Kuma to receive notifications from the AzerothCore update script and forward them to Discord.

## Overview

The notification flow is:

```
Update Script → Uptime Kuma (Push Monitor) → Discord Webhook
```

Uptime Kuma acts as a central notification hub, receiving push notifications from the update script and forwarding them to Discord (or other notification channels you configure).

## Prerequisites

- Uptime Kuma installed and accessible at: `http://192.168.144.3:3001` or `http://homeassistant.rollet.family:3001`
- Discord webhook URL (already configured): `https://discord.com/api/webhooks/1445557884950679647/Eiksy7TTGH9c6uiJrtUE3cWx6XECrSJR814XfV0KAZfvQQ0IeAxLLGKXa-IxeM9Nip8o`
- Access to the AzerothCore server at `root@AzerothCore`

---

## Part 1: Manual Setup in Uptime Kuma UI

### Step 1: Create a Push Monitor

1. Log into Uptime Kuma web interface
2. Click **"Add New Monitor"**
3. Configure the monitor:
    - **Monitor Type**: Select **"Push"**
    - **Friendly Name**: `AzerothCore Updates` (or your preferred name)
    - **Heartbeat Interval**: `1440` minutes (24 hours)
        - This matches the daily git-only update schedule
    - **Retries**: `0` (push monitors don't retry)

4. Click **"Save"**

### Step 2: Get the Push URL

After saving, Uptime Kuma will display the push URL. It will look like:

```
http://192.168.144.3:3001/api/push/XXXXXXXX?status=up&msg=OK&ping=
```

**Important parts:**

- `XXXXXXXX` is your unique push key (8+ character string)
- Keep this URL private - anyone with it can send notifications

**Copy this entire URL** - you'll need it in Step 4.

### Step 3: Configure Discord Notification

1. In the monitor settings, scroll to **"Notifications"**
2. Click **"Setup Notification"**
3. Select **"Discord"** from the notification type dropdown
4. Configure Discord settings:
    - **Friendly Name**: `Discord - AzerothCore`
    - **Discord Webhook URL**: Paste your webhook URL
        ```
        https://discord.com/api/webhooks/1445557884950679647/Eiksy7TTGH9c6uiJrtUE3cWx6XECrSJR814XfV0KAZfvQQ0IeAxLLGKXa-IxeM9Nip8o
        ```
    - **Bot Display Name**: `AzerothCore Bot` (optional)
    - **Prefix Custom Message**: Leave empty or customize
5. Click **"Test"** to verify Discord receives the notification
6. Click **"Save"**
7. Make sure the notification is **enabled** (toggle switch on)

### Step 4: Configure the Update Script

On your AzerothCore server:

```bash
cd /root/azerothcore-wotlk

# Copy the template
cp .notification-config.template .notification-config

# Edit with your push URL
vim .notification-config
# Press 'i' for insert mode, edit the URL, then ESC and :wq to save
```

Replace the placeholder URL with your actual push URL from Step 2:

```bash
# IMPORTANT: Use only the base URL without query parameters
# The script adds ?status=...&msg=... automatically
UPTIME_KUMA_PUSH_URL="http://192.168.144.3:3001/api/push/XXXXXXXX"
```

**Note:** Uptime Kuma will show you a URL like:

```
http://192.168.144.3:3001/api/push/XXXXXXXX?status=up&msg=OK&ping=
```

But you should only use the part **before the `?`** in your config file. The script adds the status and message parameters automatically.

### Step 5: Test the Integration

Test that everything works:

```bash
# Test notification only (no actual update)
./update-azerothcore.sh --dry-run
```

You should see:

1. Console output showing "DRY RUN MODE"
2. A notification appear in Uptime Kuma
3. The notification forwarded to Discord

If you don't see notifications:

- Check `.notification-config` has the correct URL
- Verify the push URL is accessible from the server
- Check Uptime Kuma logs for errors
- Verify Discord webhook is still valid

---

## Part 2: Automated Setup via Uptime Kuma API

If you prefer to automate the Uptime Kuma configuration, you can use the API.

### Prerequisites for Automation

1. Generate an API key in Uptime Kuma:
    - Go to **Settings** → **Security**
    - Scroll to **API Keys**
    - Click **"Add API Key"**
    - Name: `AzerothCore Automation`
    - Copy the generated key

### Automated Setup Script

Save this as `setup-uptimekuma.sh` on your server:

```bash
#!/bin/bash

# Configuration
UPTIME_KUMA_URL="http://192.168.144.3:3001"
UPTIME_KUMA_API_KEY="YOUR_API_KEY_HERE"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1445557884950679647/Eiksy7TTGH9c6uiJrtUE3cWx6XECrSJR814XfV0KAZfvQQ0IeAxLLGKXa-IxeM9Nip8o"
MONITOR_NAME="AzerothCore Updates"

# Step 1: Create Discord notification endpoint
echo "Creating Discord notification endpoint..."
NOTIFICATION_RESPONSE=$(curl -s -X POST "${UPTIME_KUMA_URL}/api/notification" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${UPTIME_KUMA_API_KEY}" \
  -d '{
    "type": "discord",
    "name": "Discord - AzerothCore",
    "discordWebhookUrl": "'"${DISCORD_WEBHOOK}"'",
    "discordUsername": "AzerothCore Bot",
    "isDefault": false,
    "applyExisting": false
  }')

NOTIFICATION_ID=$(echo "$NOTIFICATION_RESPONSE" | jq -r '.id')
echo "Discord notification created with ID: $NOTIFICATION_ID"

# Step 2: Create Push monitor
echo "Creating push monitor..."
MONITOR_RESPONSE=$(curl -s -X POST "${UPTIME_KUMA_URL}/api/monitor" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${UPTIME_KUMA_API_KEY}" \
  -d '{
    "type": "push",
    "name": "'"${MONITOR_NAME}"'",
    "interval": 1440,
    "retryInterval": 60,
    "maxretries": 0,
    "notificationIDList": {
      "'"${NOTIFICATION_ID}"'": true
    }
  }')

MONITOR_ID=$(echo "$MONITOR_RESPONSE" | jq -r '.monitorID')
echo "Monitor created with ID: $MONITOR_ID"

# Step 3: Get push URL
PUSH_TOKEN=$(echo "$MONITOR_RESPONSE" | jq -r '.pushToken')
PUSH_URL="${UPTIME_KUMA_URL}/api/push/${PUSH_TOKEN}?status=up&msg=OK&ping="

echo ""
echo "==================================================="
echo "Setup Complete!"
echo "==================================================="
echo ""
echo "Your push URL is:"
echo "$PUSH_URL"
echo ""
echo "Add this to .notification-config:"
echo "UPTIME_KUMA_PUSH_URL=\"$PUSH_URL\""
echo ""
```

### Run the Automated Setup

```bash
# Make executable
chmod +x setup-uptimekuma.sh

# Edit to add your API key
vim setup-uptimekuma.sh
# Press 'i' for insert mode, edit, then ESC and :wq to save

# Run the setup
./setup-uptimekuma.sh
```

The script will output your push URL. Copy it to `.notification-config` as shown in Part 1, Step 4.

---

## Understanding Push Monitor Status

The update script sends different status messages to Uptime Kuma:

### Success Status (Green)

```
status=up&msg=Update%20completed%20successfully
```

Sent when:

- Git updates complete successfully
- Docker rebuild completes successfully
- No errors detected

### Failure Status (Red)

```
status=down&msg=Update%20failed
```

Sent when:

- Git update fails
- Docker rebuild fails
- Script encounters errors

### Heartbeat (Ping)

The script also sends a ping value with elapsed time:

```
ping=1234
```

This shows how long the operation took (in milliseconds).

---

## Notification Examples

### Successful Git-Only Update

**Uptime Kuma Status**: UP (Green)
**Discord Message**:

```
[AzerothCore Updates] ✅ UP
Update completed successfully

Git Changes:
- Updated core repository
- Updated 2 modules:
  * mod-playerbots
  * mod-ah-bot

Next scheduled run: Tomorrow at 4:15 PM EST
```

### Successful Full Rebuild

**Uptime Kuma Status**: UP (Green)
**Discord Message**:

```
[AzerothCore Updates] ✅ UP
Update completed successfully

Git Changes:
- Updated core repository
- No module changes

Docker Build:
- Build time: 45 minutes
- All services restarted successfully

Next scheduled run: Tomorrow at 4:15 PM EST
```

### Failed Update

**Uptime Kuma Status**: DOWN (Red)
**Discord Message**:

```
[AzerothCore Updates] ❌ DOWN
Update failed

Error: Docker build failed after 60 minutes (timeout)

Repository rolled back to previous state.
Check logs: /root/logs/update_YYYYMMDD_HHMMSS.log

Action required: Manual intervention needed
```

### Blocked Update (Local Changes)

**Uptime Kuma Status**: UP (Green)
**Discord Message**:

```
[AzerothCore Updates] ⚠️ SKIPPED
Update blocked: Local changes detected

Modified files:
- modules/mod-custom/src/custom.cpp
- conf/worldserver.conf

Action required: Commit or stash changes before next update
```

---

## Monitoring Best Practices

### 1. Heartbeat Interval

- Set to **1440 minutes (24 hours)** to match daily update schedule
- Uptime Kuma will alert if script hasn't run in 24+ hours
- Weekly rebuild still counts as a heartbeat

### 2. Alert Timing

Configure Uptime Kuma to send alerts when:

- Monitor goes DOWN (build failures)
- Monitor hasn't received heartbeat in 25+ hours (script not running)

### 3. Log Retention

- Update script keeps logs for 90 days
- Check logs when notifications indicate failures
- Logs location: `/root/logs/`

### 4. Testing Schedule

Test notifications:

- **Monthly**: Run `./update-azerothcore.sh --dry-run` to verify notification flow
- **After changes**: Test when modifying Discord webhook or Uptime Kuma config
- **Before cron setup**: Verify everything works manually first

---

## Troubleshooting

### No Notifications Received

1. **Check script configuration**:

    ```bash
    cat /root/azerothcore-wotlk/.notification-config
    # Verify UPTIME_KUMA_PUSH_URL is set correctly
    ```

2. **Test push URL manually**:

    ```bash
    curl "http://192.168.144.3:3001/api/push/XXXXXXXX?status=up&msg=Test&ping="
    ```

    Check if notification appears in Uptime Kuma.

3. **Check network connectivity**:

    ```bash
    ping 192.168.144.3
    curl -I http://192.168.144.3:3001
    ```

4. **Review script logs**:
    ```bash
    tail -100 /root/logs/update_*.log | grep -i notification
    ```

### Notifications to Uptime Kuma Work, But Not Discord

1. **Verify Discord webhook**:

    ```bash
    curl -X POST "https://discord.com/api/webhooks/1445557884950679647/Eiksy7TTGH9c6uiJrtUE3cWx6XECrSJR814XfV0KAZfvQQ0IeAxLLGKXa-IxeM9Nip8o" \
      -H "Content-Type: application/json" \
      -d '{"content": "Test message"}'
    ```

2. **Check Uptime Kuma notification settings**:
    - Verify Discord notification is **enabled** (toggle on)
    - Test notification from Uptime Kuma UI
    - Check Uptime Kuma logs for Discord API errors

3. **Discord webhook issues**:
    - Webhook may have been deleted or regenerated
    - Channel may have been deleted
    - Bot permissions may have changed

### Duplicate Notifications

If receiving multiple notifications for the same event:

- Check you haven't configured multiple notification endpoints
- Verify only one instance of the update script is running
- Check cron jobs: `crontab -l`

---

## Cron Schedule Setup

After verifying notifications work, set up the automated schedule:

```bash
# Edit crontab
crontab -e

# Add these lines:
# Daily git-only update at 4:15 PM EST
15 16 * * * /root/azerothcore-wotlk/update-azerothcore.sh --git-only >> /root/logs/cron.log 2>&1

# Weekly full rebuild on Sundays at 9:00 AM EST
0 9 * * 0 /root/azerothcore-wotlk/update-azerothcore.sh >> /root/logs/cron.log 2>&1
```

**Note**: Cron times are in **server time**. Adjust if your server timezone differs from EST.

Verify cron times match EST:

```bash
date  # Check current server time
TZ='America/New_York' date  # Check EST time
```

---

## Security Considerations

### Protect Your Push URL

- The push URL contains authentication - keep it private
- Store in `.notification-config` (excluded from git)
- Don't share in public channels or documentation
- Regenerate monitor if URL is compromised

### Discord Webhook Security

- Webhook URL is in the template (already committed to git)
- If concerned, regenerate webhook in Discord and update:
    1. Discord channel settings
    2. `.notification-config.template`
    3. Uptime Kuma notification settings

### API Key Security (Automated Setup)

- API keys provide full access to Uptime Kuma
- Store securely, never commit to git
- Use separate API key per automation
- Revoke keys when no longer needed

---

## Additional Resources

- **Uptime Kuma Documentation**: https://github.com/louislam/uptime-kuma/wiki
- **Discord Webhook Guide**: https://support.discord.com/hc/en-us/articles/228383668
- **Update Script Documentation**: See `README-TrueNAS-Scale-Updates.md`

---

## Quick Reference

### Important Files

- `.notification-config` - Contains push URL (create from template)
- `.notification-config.template` - Template with placeholder
- `update-azerothcore.sh` - Main update script
- `~/logs/update_*.log` - Update execution logs
- `~/logs/cron.log` - Cron job execution log

### Important URLs

- Uptime Kuma: `http://192.168.144.3:3001`
- Alternative URL: `http://homeassistant.rollet.family:3001`
- Discord Webhook: `https://discord.com/api/webhooks/1445557884950679647/...`

### Quick Commands

```bash
# Test notification (dry run)
./update-azerothcore.sh --dry-run

# Manual git-only update
./update-azerothcore.sh --git-only

# Manual full update + rebuild
./update-azerothcore.sh

# Check cron schedule
crontab -l

# View recent logs
tail -f logs/update_*.log
```

---

## Summary

You now have:

1. ✅ Push monitor in Uptime Kuma
2. ✅ Discord notification configured
3. ✅ Update script configured with push URL
4. ✅ Tested notification flow
5. ✅ Cron schedule set up (optional)

The system will now automatically:

- Update AzerothCore and modules daily at 4:15 PM EST
- Rebuild Docker containers weekly on Sundays at 9:00 AM EST
- Send notifications for all update events to Discord via Uptime Kuma
- Alert if updates fail or script doesn't run as scheduled

**Next step**: Monitor the first few automated runs to ensure everything works as expected!
