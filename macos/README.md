## Installation
1. execute ./install.sh
1. in your ~/.zprofile specify
```
export DOTFILES_PATH="<PATH>"
source $DOTFILES_PATH/macos/.bashrc
```
1. extra fixes
  * extend banner display time `defaults write com.apple.notificationcenterui bannerTime -int 5 && killall NotificationCenter`