#!/bin/bash
[[ -f ~/.zshrc ]] && source ~/.zshrc || source ~/.bashrc

MAC_OS_BROWSER='open -n /Applications/Google\ Chrome.app --args'
#MAC_OS_BROWSER='open -n /Applications/Brave\ Browser.app --args'
#MAC_OS_BROWSER='open -n /Applications/Chromium.app --args'
LINUX_OS_BROWSER='brave'

BROWSER=`isMac && echo $MAC_OS_BROWSER || echo $LINUX_OS_BROWSER`

eval "$BROWSER" --app="https://www.evernote.com/client/web?login=true" --class="web-app"

