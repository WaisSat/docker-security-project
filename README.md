![Security Hardened](https://img.shields.io/badge/Security-Hardened-green?style=for-the-badge&logo=docker)

# 🛡️ Hardened Python Web Environment

This project demonstrates a **Security-First** approach to containerization. Instead of using default Docker settings, this environment implements a "Zero-Trust" architecture to protect the application from common container escapes and exploits.

## 🚀 Key Security Features

| Feature | Implementation | Defense Mechanism |
| :--- | :--- | :--- |
| **Least Privilege** | `cap_drop: ALL` | Strips all Linux kernel capabilities. |
| **Immutability** | `read_only: true` | Prevents unauthorized file modification or malware persistence. |
| **Network Isolation** | `internal: true` | Blocks egress traffic to prevent data exfiltration and C2 callbacks. |
| **Identity Security** | `USER appuser` | Runs the process as a non-root UID 10001 to limit host impact. |
| **Privilege Control** | `no-new-privileges` | Blocks SUID/SGID elevation attacks. |
| **Resource Limits** | `cpus: 0.5 / mem: 256M` | Mitigates local Denial of Service (DoS) attacks. |

## 🛠️ Project Structure

* `app.py`: Minimal Python web server (Standard Library).
* `audit.sh`: Custom bash script to verify container hardening at runtime.
* `docker-compose.yml`: Orchestration file containing security constraints.
* `Dockerfile`: Multi-stage ready, non-root image configuration.

## 📊 Security Validation

To verify the hardening, run the included audit script:

```bash
chmod +x audit.sh
./audit.sh secured-python-app
