# OpenClaw Cross-Device Sync Setup

## Structure

```
openclaw-config/
├── .gitignore          # Excludes all sensitive data
├── tokens/
│   ├── desktop.env     # Desktop tokens (600 permissions)
│   ├── laptop.env      # Laptop tokens (to be created on laptop)
│   └── laptop.env.example  # Template for laptop
└── run-openclaw.sh     # Launcher script
```

## Security

- `tokens/` directory: chmod 700 (owner only)
- Token files: chmod 600 (owner read/write only)
- Nothing in `tokens/` is ever committed to git
- `run-openclaw.sh` sources tokens before launching

## Usage

```bash
cd ~/openclaw-config

# On desktop
./run-openclaw.sh desktop

# On laptop
./run-openclaw.sh laptop
```

## Setup on Laptop

1. Clone this repo to `~/openclaw-config`
2. Copy `tokens/laptop.env.example` to `tokens/laptop.env`
3. Fill in the laptop-specific tokens:
   - `DISCORD_TOKEN` (new laptop Discord token)
   - `OPENCLAW_GATEWAY_TOKEN` (can be the same if you want to link devices)
4. Symlink credentials for WhatsApp if needed

## Sync Config (not tokens)

To sync skills, agents, and instructions (excluding runtime data):

```bash
# Push changes
git add skills/ agents/ instructions/ workspace/
git commit -m "Update config"
git push

# Pull changes
git pull
```

## Manual Token Update

On desktop, edit tokens:
```bash
nano ~/openclaw-config/tokens/desktop.env
```

Then push config changes separately from tokens (tokens stay local).
