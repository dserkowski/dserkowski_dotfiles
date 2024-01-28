#!/bin/bash
[[ -f ~/.zshrc ]] && source ~/.zshrc || source ~/.bashrc

BROWSER=`isMac && echo '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' || echo 'brave'`

"$BROWSER" --app="https://www.evernote.com/client/web?login=true" --class="web-app"

