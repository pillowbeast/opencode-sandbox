# AI Agent Secure Sandbox Template

## What is this?

A hardened, containerized environment for running AI coding agents (like Claude/OpenCode) safely. It prevents agents from accessing host credentials, restricts internet access to an approved allowlist, and isolates project dependencies.

## Why use it?

- **Credential Security**: Masks your `.env` and `.git/config` so agents can't leak secrets.
- **Network Control**: Uses a Squid proxy to ensure the agent only talks to Anthropic, Google, and NPM—blocking unauthorized data exfiltration.
- **Non-Root Isolation**: Runs as a restricted user with dropped Linux capabilities to protect your host OS.

## Setup Instructions

### 1. Initialize the Environment

Create a `.env` file in this directory to name your project and avoid container collisions:

```bash
echo "PROJECT_NAME=$(basename "$PWD")" > .env
```

### 2. Configure the Allowlist

Review `squid.conf`. Add any additional domains your agent might need (e.g., specific API documentation sites).

### 3. Configure OpenCode (if needed)

The sandbox mounts `~/.config/opencode` from your host into the container. Add or modify config there before running if the agent needs custom settings:

```
~/.config/opencode/
├── opencode.json <--
├── ...
```

### 4. Build and Start

```bash
docker-compose build
docker-compose up -d
```

### 5. Enter the Sandbox

```bash
docker exec -it $(docker ps -qf "name=-sandbox") bash
```

### 6. Run Your Agent

Once inside, simply run `opencode`. The environment is pre-configured to use the internal proxy and your host's active login session.
