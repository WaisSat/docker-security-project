#!/bin/bash

# Use the first argument as ID, or fall back to your current ID
CONTAINER_ID="${1:-secured-nginx}"

echo "--- 🛡️ Docker Security Audit for: $CONTAINER_ID ---"

# 1. User Identity
echo -n "[?] Running as: "
docker exec $CONTAINER_ID whoami

# 2. Check for Sudo availability
echo -n "[?] Sudo present: "
docker exec $CONTAINER_ID command -v sudo >/dev/null 2>&1 && echo "YES (Potential Risk)" || echo "NO"

# 3. Check for Root FS Status
echo -n "[?] Root FS Read-Only: "
IS_RO=$(docker inspect --format='{{.HostConfig.ReadonlyRootfs}}' $CONTAINER_ID)
[[ "$IS_RO" == "true" ]] && echo "YES ✅" || echo "NO ❌ (Writable)"

# 4. Check for world-writable directories
echo "[!] World-writable directories (excluding tmpfs):"
docker exec $CONTAINER_ID find / -xdev -type d -perm -0002 ! -path "/tmp*" ! -path "/var/tmp*" ! -path "/var/run*" ! -path "/var/cache/nginx*" ! -path "/var/log/nginx*" 2>/dev/null | sed 's/^/    /' || echo "    None found."

# 5. Check Linux Capabilities
echo "[!] Effective Capabilities (Raw):"
CAP_HEX=$(docker exec $CONTAINER_ID grep "CapEff" /proc/1/status | awk '{print $2}')
echo "    CapEff: $CAP_HEX"
echo "    (Decode on host with: capsh --decode=$CAP_HEX)"

# 6. SUID/SGID Binaries (The "Secret" Escalation Paths)
echo "[!] SUID/SGID Binaries found:"
# Looking for bits 4000 (SUID) or 2000 (SGID)
SUID_FILES=$(docker exec $CONTAINER_ID find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null)
if [ -z "$SUID_FILES" ]; then
    echo "    None found ✅"
else
    echo "$SUID_FILES" | sed 's/^/    - /'
fi

echo "--- Audit Complete ---"