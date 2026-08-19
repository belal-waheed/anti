---
name: cicd-docker-devops
description: Conventions and patterns for CI/CD pipelines, Docker containerization, and DevOps workflows. Use when creating or debugging Dockerfiles, docker-compose configurations, GitHub Actions workflows, automated testing pipelines, or deployment setups.
---

# CI/CD, Docker & DevOps Engineering Guide

## When to use this skill
Trigger whenever writing, optimizing, or debugging multi-stage Dockerfiles, `docker-compose.yml` configurations, GitHub Actions CI/CD workflows, automated testing pipelines, or container deployment configurations.

---

## 1. Core Principles of Production DevOps

1. **Multi-Stage Builds**: Keep production container images minimal, fast, and free of build-time tooling (compilers, npm devDependencies).
2. **Non-Root Execution**: Never run application processes as `root` inside containers.
3. **Deterministic CI/CD Pipelines**: Run linters, type checkers, and unit test suites on every pull request before allowing merge or build artifacts.
4. **Secret Isolation**: Never bake secrets or `.env` files into Docker images. Inject environment variables at runtime.

---

## 2. Production Multi-Stage Dockerfiles

### A. Node.js / React Multi-Stage Dockerfile
```dockerfile
# syntax=docker/dockerfile:1

# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production Runtime
FROM nginx:alpine-slim AS runner
WORKDIR /usr/share/nginx/html
# Remove default nginx assets
RUN rm -rf ./*
# Copy built assets from builder
COPY --from=builder /app/dist .
# Custom non-root nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### B. Python FastAPI Multi-Stage Dockerfile
```dockerfile
# syntax=docker/dockerfile:1

# Stage 1: Build Dependencies
FROM python:3.12-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.12-slim AS runner
WORKDIR /app
# Create non-root user
RUN addgroup --system appgroup && adduser --system --group appuser
# Copy dependencies from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appgroup src/ ./src

ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## 3. GitHub Actions CI/CD Pipeline (`.github/workflows/ci.yml`)

Standard pipeline enforcing typecheck, lint, and unit tests:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  validate:
    name: Lint, Typecheck & Unit Tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      - name: Run Linter
        run: npm run lint

      - name: Run Typecheck
        run: npm run typecheck

      - name: Run Unit Tests with Coverage
        run: npm run test:coverage

      - name: Verify Build
        run: npm run build
```

---

## 4. Local Multi-Service `docker-compose.yml`

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:secret@db:5432/appdb
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    restart: unless-stopped
    ports:
      - "6379:6379"

volumes:
  pgdata:
```

---

## Things to Avoid

- Avoid using the `:latest` tag for base images in production Dockerfiles — pin specific version tags (`node:20.11-alpine`, `python:3.12-slim`).
- Never run production containers as `root`.
- Avoid committing `.env`, `credentials.json`, or `.pem` files into git repositories.
- Never skip running tests in CI before triggering deployment steps.
