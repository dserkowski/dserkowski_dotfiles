Toggle-Wifi safe/
===================

This folder contains a safer rewrite of the original project:
- no bundled notifier binaries
- no shell=True
- notifications use terminal-notifier and osascript

Files
-----
- toggle-wifi.py   main logic
- toggle-wifi      shell wrapper
- service.plist    launchd agent template using an absolute path

Requirements
------------
- macOS
- python3
- networksetup
- ifconfig
- osascript
- optional: terminal-notifier

Install terminal-notifier
-------------------------
brew install terminal-notifier

Manual run
----------
./toggle-wifi

Dry run
-------
./toggle-wifi --dry-run
or
python3 ./toggle-wifi.py --dry-run

Create a user LaunchAgent
-------------------------
1. Replace __SAFE_TOGGLE_WIFI_PATH__ in service.plist with the absolute path to the safe/toggle-wifi script.
2. Copy the plist to ~/Library/LaunchAgents/safe.toggle-wifi.plist
3. Load it:
   launchctl unload ~/Library/LaunchAgents/safe.toggle-wifi.plist 2>/dev/null || true
   launchctl load ~/Library/LaunchAgents/safe.toggle-wifi.plist

Behavior
--------
- turns Wi-Fi off when Ethernet becomes active
- turns Wi-Fi back on when Ethernet disconnects and Wi-Fi is off
- stores previous Ethernet state in /tmp/toggle-wifi_prev_eth_conn

Notes
-----
- dry-run prints what would happen and does not toggle Wi-Fi
- if terminal-notifier is missing, notifications are skipped silently
- logs are written to ~/Library/Logs/safe-toggle-wifi.log
- use ./status-launch-agent.sh to check whether the LaunchAgent is loaded
- uninstall script re-enables Wi-Fi before removing the LaunchAgent
