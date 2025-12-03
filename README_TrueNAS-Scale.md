# AzerothCore on TrueNAS Scale - Docker Runtime Fix
## Problem Overview
When running AzerothCore inside a TrueNAS Scale system container, Docker containers fail to start with the following error:
```
Error response from daemon: failed to create task for container: failed to create shim task: 
OCI runtime create failed: runc create failed: unable to start container process: 
error during container init: open sysctl net.ipv4.ip_unprivileged_port_start file: 
reopen fd 8: permission denied
```
## Root Cause
This issue occurs due to a combination of factors:
### 1. **Nested Container Restrictions**
TrueNAS Scale uses LXC containers, which create a nested containerization scenario:
- **Host**: TrueNAS Scale system
- **Layer 1**: LXC system container (where you SSH into)
- **Layer 2**: Docker containers (AzerothCore services)
LXC restricts nested containers from accessing certain kernel parameters (sysctls), even when the file exists and is readable at the LXC container level.
### 2. **MySQL 8.x Network Optimizations**
Modern MySQL images (8.0+, especially 8.4) attempt to optimize network settings by modifying the `net.ipv4.ip_unprivileged_port_start` sysctl during container initialization. This optimization:
- Allows MySQL to bind to privileged ports (< 1024) without root
- Improves network performance
- **Requires write/read access to `/proc/sys/net/ipv4/ip_unprivileged_port_start`**
### 3. **runc Limitations**
The default Docker OCI runtime (`runc`) strictly enforces sysctl access requirements. When running in nested containers:
- `runc` attempts to read the sysctl file during container initialization
- LXC blocks this access due to security restrictions
- Container creation fails immediately
### Why It Started Happening
This issue typically appears after:
- **Updating AzerothCore repository**: New docker-compose.yml may specify newer MySQL versions
- **Updating Docker**: Newer versions (29.x+) have stricter security enforcement
- **Updating runc**: Versions 1.2+ have stricter sysctl validation
- **Updating MySQL image**: MySQL 8.4 introduced more aggressive network optimizations
## The Solution: Using `crun` Runtime
`crun` is an alternative OCI runtime that handles nested container scenarios more gracefully than `runc`. It:
- Has better compatibility with LXC/nested containers
- Gracefully handles sysctl permission errors instead of failing
- Maintains full OCI specification compliance
- Is written in C (vs Go for runc), making it faster and lighter
## Installation Steps
Run these commands **inside your TrueNAS Scale container** (via SSH):
### 1. Install crun
```bash
# Update package lists and install crun
sudo apt update && sudo apt install -y crun
# Verify installation
which crun
crun --version
```
Expected output:
```
/usr/bin/crun
crun version 1.x.x
...
```
### 2. Configure Docker to Use crun
Create Docker daemon configuration:
```bash
sudo tee /etc/docker/daemon.json > /dev/null << 'EOF'
{
  "default-runtime": "crun",
  "runtimes": {
    "crun": {
      "path": "/usr/bin/crun"
    }
  }
}
EOF
```
### 3. Restart Docker Service
```bash
# Restart Docker daemon
sudo systemctl restart docker
# Verify Docker is running
sudo systemctl status docker
# Check that crun is configured
docker info | grep -i runtime
```
Expected output should show:
```
Runtimes: crun runc
Default Runtime: crun
```
### 4. Test the Fix
```bash
# Test with a simple container
docker run --rm hello-world
# Test with MySQL/MariaDB
docker run --rm -e MYSQL_ROOT_PASSWORD=test mariadb:10.11 mysqld --version
```
If these commands succeed without sysctl errors, the fix is working.
### 5. Start AzerothCore
```bash
cd ~/azerothcore-wotlk
sudo docker compose up -d --build
```
## Verification
Check that all containers are running:
```bash
docker ps
# Should show:
# - ac-database (MariaDB or MySQL)
# - ac-worldserver
# - ac-authserver
# - ac-db-import (may exit after completing)
# - ac-client-data-init (may exit after completing)
```
Check container logs if issues persist:
```bash
docker logs ac-database
docker logs ac-worldserver
docker logs ac-authserver
```
## Alternative: TrueNAS Container Configuration
If the `crun` workaround doesn't work, you need to modify the TrueNAS Scale container settings:
1. Navigate to **TrueNAS Web UI** → **Virtualization** → **Containers**
2. Stop the AzerothCore container
3. Edit container settings:
   - Enable **Privileged Container**
   - Add **Security Options**: `apparmor:unconfined`
   - Add **Capabilities**: `SYS_ADMIN`, `NET_ADMIN`
4. Under **Advanced Settings** or **Raw Config**, add:
   ```
   lxc.apparmor.profile = unconfined
   lxc.mount.auto = proc:rw sys:rw
   lxc.cap.drop =
   ```
5. Save and restart the container
## Docker Compose Configuration Note
The `docker-compose.override.yml` has been modified to use **MariaDB 10.11** instead of MySQL 8.4:
```yaml
services:
  ac-database:
    image: mariadb:10.11  # Instead of mysql:8.4
```
**Why MariaDB?**
- Fully compatible with MySQL 8.0/8.4
- Less aggressive with sysctl requirements
- Better suited for nested container environments
- Maintains all AzerothCore functionality
## Troubleshooting
### Issue: `crun: command not found`
```bash
# Check if universe repository is enabled
sudo add-apt-repository universe
sudo apt update
sudo apt install -y crun
```
### Issue: Docker won't start after configuration
```bash
# Check Docker logs
sudo journalctl -u docker -n 50
# Verify daemon.json syntax
sudo cat /etc/docker/daemon.json | jq .
# If syntax error, recreate the file
sudo rm /etc/docker/daemon.json
# Then repeat step 2 from installation
```
### Issue: Still getting sysctl errors
1. Verify `crun` is the default runtime:
   ```bash
   docker info | grep "Default Runtime"
   ```
2. If still showing `runc`, force `crun` per container:
   ```bash
   docker run --runtime=crun --rm hello-world
   ```
3. Update docker-compose.yml to specify runtime:
   ```yaml
   services:
     ac-database:
       runtime: crun
   ```
### Issue: Containers start but database fails
Check if the database volume has permission issues:
```bash
# Remove old database volume
docker volume rm azerothcore-wotlk_ac-database
# Restart compose
docker compose up -d --build
```
## Performance Notes
`crun` is generally **faster** than `runc`:
- 20-30% faster container startup
- Lower memory footprint
- Better CPU efficiency
This makes it an excellent choice even outside of nested container scenarios.
## References
- [crun GitHub Repository](https://github.com/containers/crun)
- [Docker Runtime Configuration](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)
- [TrueNAS Scale Documentation](https://www.truenas.com/docs/scale/)
- [OCI Runtime Specification](https://github.com/opencontainers/runtime-spec)
## Summary
The `crun` runtime is a drop-in replacement for `runc` that handles nested container environments (like TrueNAS Scale's LXC containers) more gracefully. By switching to `crun`, Docker containers can start successfully without requiring privileged mode or complex LXC configuration changes at the TrueNAS host level.
This solution:
- ✅ Works without modifying TrueNAS host settings
- ✅ Maintains container security
- ✅ Improves performance
- ✅ Provides long-term compatibility
- ✅ Requires minimal configuration changes

