# OpenClaw Dual-Device Setup - Conversation Archive

**Date:** April 2, 2026  
**Participants:** User (numan) + AI Assistant  
**Topic:** Configuring OpenClaw for use across desktop and laptop with shared Telegram/WhatsApp but separate Discord APIs

---

## Problem Statement

User has two computers (desktop and laptop) with OpenClaw configured:
- **Same:** Telegram (TG), WhatsApp (WA)
- **Different:** Discord API tokens

Goal: Have both work correctly when required, with synchronized skills, agents, and instructions.

---

## Solution Approach

### Option Selected: Run One Instance at a Time

Since running one at a time is acceptable, the strategy is:
1. Use machine-specific token files
2. Sync config (skills/agents/instructions) via Git
3. Keep tokens local only (never commit to git)

---

## Implementation

### Directory Structure Created

```
~/openclaw-config/
├── .gitignore              # Excludes sensitive data
├── README.md               # Setup documentation
├── run-openclaw.sh         # Launcher script
└── tokens/
    ├── desktop.env         # Desktop tokens (600 permissions)
    └── laptop.env.example  # Template for laptop tokens
```

### Security Measures

| Item | Permission | Purpose |
|------|------------|---------|
| `tokens/` directory | 700 | Owner-only access |
| `desktop.env` | 600 | Owner read/write only |
| `.gitignore` | Excludes all tokens/ | Prevents accidental commits |
| `run-openclaw.sh` | 700 | Executable launcher |

### Token File: `tokens/desktop.env`

```bash
# OpenClaw Desktop Tokens - DO NOT COMMIT THIS FILE
# Keep permissions: chmod 600 this file

# Gateway Token
OPENCLAW_GATEWAY_TOKEN=5f685395940485e39b6faa890a7e87214c7359f9a53fc94c

# Telegram
TG_BOT_TOKEN=7456699838:AAEl-krCQ6kFiuJkWGgF2NhqNGNl9hnTtUQ
TG_API_ID=
TG_API_HASH=
TG_PHONE=

# Discord
DISCORD_TOKEN=<token removed>

# WhatsApp
WA_SESSION_PATH=~/.openclaw/credentials/whatsapp

# OpenRouter
OPENROUTER_API_KEY=

# Machine identifier
MACHINE_NAME=desktop
```

### Token File: `tokens/laptop.env.example`

```bash
# OpenClaw Laptop Tokens Template - COPY THIS TO laptop.env
# Fill in your laptop-specific values

# Gateway Token
OPENCLAW_GATEWAY_TOKEN=

# Telegram (same as desktop)
TG_BOT_TOKEN=7456699838:AAEl-krCQ6kFiuJkWGgF2NhqNGNl9hnTtUQ
TG_API_ID=
TG_API_HASH=
TG_PHONE=

# Discord (LAPTOP SPECIFIC)
DISCORD_TOKEN=

# WhatsApp
WA_SESSION_PATH=~/.openclaw/credentials/whatsapp

# OpenRouter
OPENROUTER_API_KEY=

# Machine identifier
MACHINE_NAME=laptop
```

### Launcher Script: `run-openclaw.sh`

```bash
#!/bin/bash
# OpenClaw Launcher - Sources tokens and runs OpenClaw
# Usage: ./run-openclaw.sh [desktop|laptop]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN_FILE="$SCRIPT_DIR/tokens/${1:-desktop}.env"

if [ ! -f "$TOKEN_FILE" ]; then
    echo "Error: Token file not found: $TOKEN_FILE"
    echo "Usage: $0 [desktop|laptop]"
    exit 1
fi

# Source the token file
source "$TOKEN_FILE"

# Validate critical tokens are set
if [ -z "$DISCORD_TOKEN" ]; then
    echo "Error: DISCORD_TOKEN not set in $TOKEN_FILE"
    exit 1
fi

# Launch OpenClaw
exec openclaw "$@"
```

### Git Ignore: `.gitignore`

```gitignore
# Token files (contain sensitive data)
tokens/
*.env
*.env.*

# OpenClaw runtime data (device-specific)
credentials/
identity/
logs/
telegram/
devices/
canvas/

# Session data
*.session
*.session-journal

# Backup files
*.bak
*.bak.*

# OS files
.DS_Store
Thumbs.db

# Environment secrets
.env
.env.*
```

---

## Setup Instructions

### On Desktop (Already Done)

1. Token structure created at `~/openclaw-config/`
2. Desktop tokens extracted from `~/.openclaw/openclaw.json`
3. Git initialized (pending first commit)

### On Laptop (Pending)

1. Clone the git repo to `~/openclaw-config`
2. Copy `tokens/laptop.env.example` to `tokens/laptop.env`
3. Fill in laptop-specific tokens:
   - `DISCORD_TOKEN` (new laptop Discord token)
   - `OPENCLAW_GATEWAY_TOKEN` (same if linking devices)
4. Set secure permissions:
   ```bash
   chmod 700 ~/openclaw-config/tokens
   chmod 600 ~/openclaw-config/tokens/laptop.env
   chmod 700 ~/openclaw-config/run-openclaw.sh
   ```

### Syncing WhatsApp Session

WhatsApp authentication is stored in `~/.openclaw/credentials/whatsapp/`. Options:
- **Copy** the folder when switching machines
- **Symlink** to a shared location
- Accept QR code re-authentication on the other machine

### Syncing Config Files

To sync skills, agents, and instructions:

```bash
# Push changes
cd ~/openclaw-config
git add skills/ agents/ instructions/ workspace/
git commit -m "Update config"
git push

# Pull changes on other machine
git pull
```

---

## Key Decisions Made

1. **Git-based sync** for config files (not tokens)
2. **Machine-specific `.env` files** for tokens
3. **Single source of truth** for skills/agents/instructions
4. **Tokens stay local** - never committed to git
5. **One instance at a time** - no duplicate responses issue

---

## Future Considerations

- [ ] Sync WhatsApp session between machines
- [ ] Verify OpenClaw reads tokens from environment variables
- [ ] Test `run-openclaw.sh` works correctly
- [ ] Set up git remote (GitHub/GitLab) for cross-machine sync
- [ ] Document any OpenClaw-specific environment variable names

---

## Related OpenClaw Files (Desktop Reference)

Located in `~/.openclaw/`:
- `openclaw.json` - Main config (tokens extracted from here)
- `identity/` - Device authentication
- `credentials/whatsapp/` - WhatsApp session data
- `agents/` - Agent configurations
- `devices/` - Paired devices info

---

*This document was auto-generated from conversation archive on 2026-04-02*
