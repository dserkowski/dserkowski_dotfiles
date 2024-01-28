#!/bin/bash
[[ -f ~/.zshrc ]] && source ~/.zshrc || source ~/.bashrc

if [[ -z "$1" ]]; then
    echo "ERROR: text is not provided"
    exit -1
fi

# osascript <<EOS
#     tell application "System Events"
#         set textToType to "$current_date"
#         keystroke textToType
#     end tell
# EOS
# osascript <<EOS
#     tell application "System Events" to keystroke "A phrase" & return & "Another phrase"
# EOS
isMac && osascript <<EOS
    tell application "System Events" to keystroke "$1"
EOS

! isMac && xdotool type "$1"
