#!/bin/bash
[[ -f ~/.zshrc ]] && source ~/.zshrc || source ~/.bashrc

BROWSER=`isMac && echo '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' || echo 'brave'`
#BROWSER=`isMac && echo '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser' || echo 'brave'`

("$BROWSER" --app="https://web.whatsapp.com" --class="web-app" 1> /dev/null 2> /dev/null) &
