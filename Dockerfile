# ─── Stage 1: Build ───────────────────────────────────────────────────────────
FROM node:24-slim AS builder

WORKDIR /app

# Install git if needed for npm ci
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy package files first (layer caching)
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Copy the rest of the source
COPY . .

# Build static HTML pages from views/
RUN node scripts/build-pages.js

# ─── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM node:24-slim

# Install cron, git, tar, ca-certificates, curl, and mudslide globally
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    git \
    tar \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g mudslide

# Fix cron PAM issue in Docker containers (prevents silent cron failures)
RUN sed -i '/pam_loginuid.so/c session optional pam_loginuid.so' /etc/pam.d/cron 2>/dev/null || true

WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app /app

# Create users directory for session persistence
RUN mkdir -p /app/users

# Create entrypoint script that exports env vars to cron and starts both services
RUN echo '#!/bin/sh\n\
# Export all environment variables so cron jobs can access them\n\
printenv | grep -v "^_=" | grep -v "^SHLVL=" | grep -v "^PWD=" | sed "s/=\\(.*\\)/=\"\\1\"/" > /etc/environment\n\
# Also write a shell profile that cron sources\n\
printenv | grep -v "^_=" | grep -v "^SHLVL=" | grep -v "^PWD=" >> /etc/default/cron\n\
# Start cron daemon in background\n\
cron\n\
# Start the Node.js server\n\
exec node server.js\n\
' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# Expose port
EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=production
ENV MUDSLIDE_PATH=mudslide

CMD ["/app/entrypoint.sh"]
