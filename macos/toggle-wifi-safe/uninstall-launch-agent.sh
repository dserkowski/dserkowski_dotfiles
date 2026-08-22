#!/bin/bash
set -euo pipefail

PLIST_DST="$HOME/Library/LaunchAgents/safe.toggle-wifi.plist"
STATE_FILE="/tmp/toggle-wifi_prev_eth_conn"
LOG_FILE="$HOME/Library/Logs/safe-toggle-wifi.log"

launchctl bootout "gui/$(id -u)" "$PLIST_DST" 2>/dev/null || \
launchctl unload "$PLIST_DST" 2>/dev/null || true

if command -v networksetup >/dev/null 2>&1; then
    current_device="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2; exit}')"
    if [[ -n "${current_device:-}" ]]; then
        networksetup -setairportpower "$current_device" on || true
        echo "Re-enabled Wi-Fi on: $current_device"
    fi
fi

rm -f "$PLIST_DST"
rm -f "$STATE_FILE"

echo "Removed LaunchAgent: $PLIST_DST"
echo "Removed state file: $STATE_FILE"
echo "Log file kept at: $LOG_FILE"
