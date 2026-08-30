---
name: vps-management
description: Production conventions and workflows for Linux Virtual Private Server (VPS) provisioning, hardening, SSH security, Nginx/Caddy reverse proxies, Let's Encrypt SSL/TLS certificates, systemd services, Docker orchestration, UFW firewalls, Fail2Ban, and automated backups. Use when configuring or troubleshooting Linux servers.
---

# VPS Management & Linux Server Deployment Guide

Runbook for provisioning, hardening, securing, and deploying applications on Linux servers.

## 1. Initial Hardening & Firewall Checklist

```bash
# 1. Non-root user with sudo
adduser deployer && usermod -aG sudo deployer

# 2. SSH hardening: key-only auth, disable root login in /etc/ssh/sshd_config.d/hardening.conf
# PermitRootLogin no | PasswordAuthentication no

# 3. UFW Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH && ufw allow 80/tcp && ufw allow 443/tcp
ufw --force enable

# 4. Fail2ban & auto-updates
apt install -y fail2ban unattended-upgrades
systemctl enable --now fail2ban
```

---

## 2. Reverse Proxy & Process Daemon

- **Nginx / Caddy Proxy:** Route public HTTPS traffic to local upstream ports (e.g. `127.0.0.1:3000`).
- **Systemd Daemons:** Manage background apps with automatic restart and memory limits.

For complete unit templates, see [VPS Configuration Reference](references/vps-configs.md).

---

## 3. Diagnostic Commands

| Symptom | Command | Resolution |
| :--- | :--- | :--- |
| **Port Collision** | `ss -tulpn \| grep :<PORT>` | Terminate conflicting process or change port. |
| **Service Crash** | `journalctl -u <SERVICE> -xe --no-pager` | Check `.env` syntax, database connection, or permissions. |
| **OOM Killed** | `dmesg -T \| grep -i oom` | Add swapfile (`fallocate -l 2G /swapfile`) or increase RAM limits. |
| **Disk Full** | `ncdu /` or `docker system df` | Run `docker system prune -af --volumes` or rotate logs. |

---

## 4. Verification & Testing

Validate server security and service uptime:
1. **Firewall & Open Ports Verification:**
   ```bash
   ufw status verbose
   ss -tulpn
   ```
2. **Nginx Syntax & SSL Dry-run:**
   ```bash
   nginx -t
   certbot renew --dry-run
   ```
3. **Live Service Health Check:**
   ```bash
   curl -Iv http://127.0.0.1:3000/health
   ```

---

## 5. Common Pitfalls & Negative Constraints

- **Never allow password auth over SSH:** Always enforce ED25519 or RSA SSH keys.
- **Never expose raw database ports to 0.0.0.0:** Bind Postgres (5432) / Redis (6379) to `127.0.0.1` or internal Docker networks.
- **Never hardcode secrets in systemd units:** Load credentials via `EnvironmentFile=/var/www/app/.env` with `chmod 600`.
