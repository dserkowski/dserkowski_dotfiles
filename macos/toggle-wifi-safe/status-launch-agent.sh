#!/bin/bash
set -euo pipefail

LABEL="safe.toggle-wifi"
PLIST_DST="$HOME/Library/LaunchAgents/${LABEL}.plist"

if launchctl print "gui/$(id -u)/$LABEL" >/dev/null 2>&1; then
    echo "LaunchAgent loaded: $LABEL"
else
    echo "LaunchAgent not loaded: $LABEL"
fi

if [[ -f "$PLIST_DST" ]]; then
    echo "Plist exists: $PLIST_DST"
else
    echo "Plist missing: $PLIST_DST"
fi
