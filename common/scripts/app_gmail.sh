#!/bin/bash
[[ -f ~/.zshrc ]] && source ~/.zshrc || source ~/.bashrc

BROWSER=`isMac && echo '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' || echo 'brave'`

"$BROWSER" --app="https://mail.google.com/mail/u/0/#inbox" --class="web-app"
