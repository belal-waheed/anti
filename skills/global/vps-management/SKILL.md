---
name: vps-management
description: Production conventions and workflows for Linux Virtual Private Server (VPS) provisioning, hardening, SSH security, Nginx/Caddy reverse proxies, Let's Encrypt SSL/TLS certificates, systemd services, Docker orchestration, UFW firewalls, Fail2Ban, and automated backups. Use when setting up, configuring, securing, deploying to, or troubleshooting a Linux VPS (Ubuntu/Debian/Alpine).
---

# VPS Management & Linux Server Deployment Guide

## When to use this skill
Trigger whenever provisioning a new Virtual Private Server (VPS), hardening server security, configuring Nginx/Caddy reverse proxies, generating SSL/TLS certificates with Certbot, creating `systemd` daemon service units, deploying Docker containers to a remote host, configuring UFW/Fail2Ban, setting up automated backups, or diagnosing Linux server issues (port conflicts, memory exhaustion, service crashes).

---

## 1. Initial Server Hardening & Security (Day 1 Checklist)

Always execute these baseline hardening steps immediately upon provisioning a raw Linux VPS:

### A. Non-Root User & Sudo Privileges
```bash
# 1. Update package lists and upgrade system
apt update && apt upgrade -y

# 2. Create non-root deployer user
adduser deployer
usermod -aG sudo deployer

# 3. Setup SSH key for new user
mkdir -p /home/deployer/.ssh
cp /root/.ssh/authorized_keys /home/deployer/.ssh/
chown -R deployer:deployer /home/deployer/.ssh
chmod 700 /home/deployer/.ssh
chmod 600 /home/deployer/.ssh/authorized_keys
```

### B. SSH Daemon Hardening (`/etc/ssh/sshd_config.d/hardening.conf`)
```ini
# Disable root login and enforce key-only authentication
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
```
```bash
# Test config syntax and reload sshd
sshd -t && systemctl restart ssh
```

### C. Firewall Configuration (UFW)
```bash
# Set default policies
ufw default deny incoming
ufw default allow outgoing

# Allow essential ports
ufw allow OpenSSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS

# Enable firewall
ufw --force enable
ufw status verbose
```

### D. Fail2Ban & Automatic Security Updates
```bash
# Install Fail2Ban and Unattended Upgrades
apt install -y fail2ban unattended-upgrades

# Enable local jail configuration
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable --now fail2ban

# Enable automatic security patches
dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 2. Reverse Proxy & SSL/TLS Configuration

### A. Production Nginx Reverse Proxy (`/etc/nginx/sites-available/app.conf`)
```nginx
# Upstream application cluster
upstream backend_app {
    server 127.0.0.1:3000 max_fails=3 fail_timeout=10s;
    keepalive 32;
}

# HTTP to HTTPS Redirection
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}

# HTTPS Server Block
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name example.com www.example.com;

    # SSL Certificates (managed by Certbot)
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # Modern TLS Security Parameters
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Client Payload Limits
    client_max_body_size 25M;

    # Static Assets Caching
    location /static/ {
        alias /var/www/app/static/;
        expires 30d;
        add_header Cache-Control "public, no-transform";
        access_log off;
    }

    # Reverse Proxy Pass to Backend
    location / {
        proxy_pass http://backend_app;
        proxy_http_version 1.1;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### B. Certbot SSL Provisioning & Auto-Renewal
```bash
# Install Certbot with Nginx plugin
apt install -y certbot python3-certbot-nginx

# Obtain certificate and auto-configure Nginx
certbot --nginx -d example.com -d www.example.com --non-interactive --agree-tos -m admin@example.com

# Verify automated renewal dry-run
certbot renew --dry-run
```

### C. Modern Alternative: Caddyfile (`/etc/caddy/Caddyfile`)
```caddy
example.com, www.example.com {
    # Automatic HTTPS via Let's Encrypt / ZeroSSL built-in
    encode gzip zstd

    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
    }

    reverse_proxy 127.0.0.1:3000
}
```

---

## 3. Production Process Management via Systemd

Always run standalone services (Node.js, Python FastAPI, Go, .NET) via dedicated systemd units with auto-restart, security isolation, and log capturing.

### A. Example Service Unit (`/etc/systemd/system/web-app.service`)
```ini
[Unit]
Description=Production Web Application Service
After=network.target postgresql.service redis.service
Wants=network-online.target

[Service]
Type=simple
User=deployer
Group=deployer
WorkingDirectory=/var/www/web-app
EnvironmentFile=/var/www/web-app/.env

# Command to execute
ExecStart=/usr/bin/node dist/server.js
# Or for Python FastAPI:
# ExecStart=/var/www/web-app/venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 3000 --workers 4

# Reliability & Restart Strategy
Restart=always
RestartSec=5s
KillSignal=SIGINT
TimeoutStopSec=30s

# Resource Constraints & Hardening
LimitNOFILE=65535
MemoryHigh=1G
MemoryMax=1.5G
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true

# Standard Logging to Journald
StandardOutput=journal
StandardError=journal
SyslogIdentifier=web-app

[Install]
WantedBy=multi-user.target
```

### B. Systemd Lifecycle Commands
```bash
# Reload daemon after file changes
systemctl daemon-reload

# Enable service on boot and start immediately
systemctl enable --now web-app.service

# View live streaming logs
journalctl -u web-app.service -f -n 100 --no-pager
```

---

## 4. Docker & Docker Compose on VPS

### A. Clean Docker Engine Installation (Official Repo)
```bash
# Add Docker's official GPG key & repository
apt update && apt install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow deployer user to run Docker without sudo
usermod -aG docker deployer
```

### B. Production `docker-compose.yml` Pattern
```yaml
services:
  app:
    image: my-registry.com/org/app:latest
    restart: unless-stopped
    env_file: .env.production
    expose:
      - "3000"
    networks:
      - app_network
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 20s

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - app_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: ["redis-server", "--appendonly", "yes", "--requirepass", "${REDIS_PASSWORD}"]
    volumes:
      - redisdata:/data
    networks:
      - app_network
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

networks:
  app_network:
    driver: bridge

volumes:
  pgdata:
  redisdata:
```

---

## 5. Automated Backups, Log Rotation & Maintenance

### A. Automated Daily Database Backup Script (`/opt/scripts/backup-db.sh`)
```bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/var/backups/postgres"
DATE=$(date +"%Y-%m-%d_%H%M%S")
DB_NAME="production_db"
KEEP_DAYS=7

mkdir -p "${BACKUP_DIR}"

# Execute compressed backup
docker exec -t postgres_container pg_dump -U postgres -d "${DB_NAME}" | gzip > "${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# Rotate backups older than 7 days
find "${BACKUP_DIR}" -type f -name "*.sql.gz" -mtime +${KEEP_DAYS} -delete

# (Optional) Remote sync to S3 / Cloud Storage via rclone:
# rclone copy "${BACKUP_DIR}" remote-s3:my-app-backups/database/
```
```bash
# Add to crontab (Runs daily at 02:00 UTC)
# 0 2 * * * /opt/scripts/backup-db.sh >> /var/log/backup.log 2>&1
```

### B. Custom Logrotate Configuration (`/etc/logrotate.d/app-logs`)
```ini
/var/log/web-app/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 deployer deployer
    sharedscripts
    postrotate
        systemctl reload web-app.service > /dev/null 2>&1 || true
    endscript
}
```

---

## 6. Diagnostic Runbooks & Troubleshooting

| Symptom | Diagnostic Command | Root Cause & Resolution |
| :--- | :--- | :--- |
| **Port Collision** | `ss -tulpn \| grep :<PORT>` or `lsof -i :<PORT>` | Another service or abandoned worker is binding the port. Kill process or change port. |
| **Service Failed to Start** | `journalctl -u <SERVICE> -xe --no-pager` | Syntax error in `.env`, missing database connection, or permission error. |
| **OOM / Process Killed** | `dmesg -T \| grep -i oom` | Linux Out-Of-Memory killer terminated the app. Add swap space (`fallocate -l 2G /swapfile`) or adjust memory limits. |
| **High Disk Usage** | `ncdu /` or `docker system df` | Prune unused Docker layers (`docker system prune -af --volumes`) or rotate `/var/log`. |
| **SSL Handshake Failure** | `curl -Iv https://example.com` | Expired cert or missing intermediate certificate chain. Run `certbot renew`. |
| **DNS Propagation Issue** | `dig +short example.com @8.8.8.8` | Domain A/AAAA records not pointing to VPS public IP. |

---

## 7. Things to Avoid (Anti-Patterns)

- **Never** leave default SSH port with root login and password authentication enabled.
- **Never** expose raw database ports (5432, 3306, 6379, 27017) to public internet (`0.0.0.0`) unless strictly required with SSL and IP whitelist. Bind to `127.0.0.1` or internal Docker bridge networks.
- **Never** hardcode API secrets, database passwords, or private keys directly in service units or git repos. Use environment files (`.env`) with `chmod 600`.
- **Never** deploy without automated log rotation (`logrotate`), otherwise `/var/log` will eventually fill the entire root partition and cause system panics.
