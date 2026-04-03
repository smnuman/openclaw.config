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
