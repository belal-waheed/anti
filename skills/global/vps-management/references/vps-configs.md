# VPS Hardening, Nginx & Systemd Reference Configurations

## 1. Nginx Production Reverse Proxy (`/etc/nginx/sites-available/app.conf`)

```nginx
upstream backend_app {
    server 127.0.0.1:3000 max_fails=3 fail_timeout=10s;
    keepalive 32;
}

server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    location / {
        proxy_pass http://backend_app;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 2. Systemd Service Unit (`/etc/systemd/system/web-app.service`)

```ini
[Unit]
Description=Production Web Application Service
After=network.target

[Service]
Type=simple
User=deployer
Group=deployer
WorkingDirectory=/var/www/web-app
EnvironmentFile=/var/www/web-app/.env
ExecStart=/usr/bin/node dist/server.js
Restart=always
RestartSec=5s
LimitNOFILE=65535
MemoryHigh=1G
MemoryMax=1.5G
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
```
