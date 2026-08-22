#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
PLIST_SRC="$SCRIPT_DIR/service.plist"
PLIST_DST="$HOME/Library/LaunchAgents/safe.toggle-wifi.plist"
SCRIPT_PATH="$SCRIPT_DIR/toggle-wifi"

mkdir -p "$HOME/Library/LaunchAgents"
sed "s|__SAFE_TOGGLE_WIFI_PATH__|$SCRIPT_PATH|g" "$PLIST_SRC" > "$PLIST_DST"
launchctl unload "$PLIST_DST" 2>/dev/null || true
launchctl load "$PLIST_DST"
echo "Installed LaunchAgent: $PLIST_DST"
echo "Script path: $SCRIPT_PATH"
