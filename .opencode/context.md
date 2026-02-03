# Testing AzerothCore Server Context

**CRITICAL:** This is the TESTING server and uses **NUMA Node 0** exclusively.

All work in this directory is performed via SSH on:

**Host:** testing-azerothcore.rollet.family  
**User:** root  
**Working Directory:** /root/testing-azerothcore-wotlk

**SSH Command:**

```bash
ssh root@testing-azerothcore.rollet.family
```

---

## 🔌 Port Configuration

### Testing Worldserver Ports

The **testing-ac-worldserver** container exposes multiple ports:

**Primary Game Port:**
- **8085** → 8085 (Testing-AzerothCore-WotLK realm)
  - Used by: "Testing-AzerothCore-WotLK" realm in realmlist
  - This is the TEST realm port

**Additional Exposed Ports:**
- **8585** → 8585 (Production realm access - forwards to same worldserver)
- **7878** → 7878 (SOAP management/admin interface)
- **3443** → 3443 (Additional service port)
- **8787** → 8787 (Additional service port)

**Worldserver Internal Configuration:**
- `WorldServerPort = 8085` in `/root/testing-azerothcore-wotlk/env/dist/etc/worldserver.conf`

### Database Port
- **3306** → 3306 (MySQL database - testing-ac-database)

---

## ⚠️ CRITICAL: Shared Authentication Server

**IMPORTANT:** The testing server **DOES NOT use its own authserver**.

- **Auth Server Used:** Production authserver (on azerothcore.rollet.family)
- **Realm Database:** Shared with production (acore_auth database)
- **Impact:** Both production and testing realms appear in the same realm list
- **Warning:** Changes to authserver, realmlist, or account configuration affect BOTH servers

**Do NOT modify:**
- Production authserver configuration
- Realmlist entries (except for testing realm specific changes)
- Account database (acore_auth)
- Authentication ports or settings

**Testing server containers:**
- testing-ac-worldserver (game server)
- testing-ac-database (character/world data only)
- NO testing-ac-authserver (uses production)

---

## 🗄️ Database Separation

**Testing Server Databases (testing-ac-database):**
- acore_world (separate world data)
- acore_characters (separate character data)
- acore_playerbots (separate bot data)

**Production Server Databases (used by both):**
- acore_auth (accounts, realmlist) - **SHARED, DO NOT MODIFY**

---

## 📊 Container Names

All testing containers use the **testing-** prefix:
- testing-ac-worldserver
- testing-ac-database
- testing-ac-db-import
- testing-ac-client-data-init

**Note:** There is NO testing-ac-authserver container.

---

## 🎯 NUMA Configuration

**Testing Server Assignment:** NUMA Node 0 (CPUs 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38)

This is configured in `/root/testing-azerothcore-wotlk/docker-compose.override.yml`

---

## 📋 Quick Commands

### Container Management
```bash
# Check status
ssh root@testing-azerothcore.rollet.family "cd /root/testing-azerothcore-wotlk && docker compose ps"

# Restart worldserver
ssh root@testing-azerothcore.rollet.family "cd /root/testing-azerothcore-wotlk && docker compose restart ac-worldserver"

# View logs
ssh root@testing-azerothcore.rollet.family "docker logs testing-ac-worldserver --tail 50"
```

### Database Access
```bash
# Connect to testing database
ssh root@testing-azerothcore.rollet.family "docker exec -it testing-ac-database mysql -uroot -ppassword"

# Check bot count
ssh root@testing-azerothcore.rollet.family "docker exec testing-ac-database mysql -uroot -ppassword acore_characters -e \"SELECT COUNT(*) as online_bots FROM characters WHERE online=1\" 2>&1 | grep -v Warning"
```

---

## 🔗 Relationship to Production Server

**Testing Server (this context):**
- Host: testing-azerothcore.rollet.family
- Directory: /root/testing-azerothcore-wotlk
- NUMA: Node 0
- Realm: "Testing-AzerothCore-WotLK" (port 8085)

**Production Server:**
- Host: azerothcore.rollet.family  
- Directory: /root/azerothcore-wotlk
- NUMA: Node 1
- Realm: "AzerothCore-WotLK" (port 8585)
- **Provides authserver for both servers**

---

**Last Updated:** February 2, 2026  
**Status:** Testing server with shared authentication
