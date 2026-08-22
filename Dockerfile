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

WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app /app

# Create users directory for session persistence
RUN mkdir -p /app/users

# Expose port
EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=production
ENV MUDSLIDE_PATH=mudslide

# Start cron daemon in background, then launch node server
CMD ["sh", "-c", "cron && node server.js"]
