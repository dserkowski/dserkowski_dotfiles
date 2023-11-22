
# based on https://github.com/wmutschl/timeshift-autosnap-apt/blob/main/timeshift-autosnap-apt

set -e

mkdir -p /boot.efi.backup
cmd="rsync -au --delete /boot/efi/ /boot.efi.backup"
eval $cmd
echo "/boot/efi backup created into the /boot.efi.backup" >&2