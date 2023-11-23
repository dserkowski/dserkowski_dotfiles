
set -e

sudo apt update


sudo apt install -y python3-pip
pip3 -V
pip3 install --user ansible
grep -qxF 'PATH="$PATH:/home/$USER/.local/bin"' ~/.bashrc || echo 'PATH="$PATH:/home/$USER/.local/bin"' >> ~/.bashrc


#flatpak install flathub com.chmouel.gnomeNextMeetingApplet
