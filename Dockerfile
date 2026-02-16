# Multi-stage Dockerfile for secure Claude Code sandbox
# Stage 1: Builder
FROM node:22-bookworm-slim AS builder
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /build
COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml* .npmrc* ./
# (Optional) COPY packages/ examples/ ... 
# RUN pnpm install --frozen-lockfile

# Stage 2: Runtime
FROM node:22-bookworm-slim AS runtime

# Install git, certificates, and curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    wget \
    tmux \
    # Add libraries required for Playwright/Headless browsers if needed
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 && \
    rm -rf /var/lib/apt/lists/*

# Setup User
RUN usermod -l ai-agent -d /home/ai-agent -u 1000 -m node && \
    groupmod -n ai-agent -g 1000 node

# auto-create so for writable volumes
RUN mkdir -p /home/ai-agent/.local/share/opencode && \
    mkdir -p /home/ai-agent/.local/share/opencode/log /home/ai-agent/.local/state && \
    chown -R ai-agent:ai-agent /home/ai-agent

# Git configuration
RUN git config --global user.email "ai-agent@local.dev" && \
    git config --global user.name "AI Agent"

WORKDIR /workspace/project

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

USER ai-agent
CMD ["/bin/bash"]