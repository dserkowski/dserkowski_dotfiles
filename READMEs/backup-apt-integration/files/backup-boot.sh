
# based on https://github.com/wmutschl/timeshift-autosnap-apt/blob/main/timeshift-autosnap-apt

# uncomment if you don't you btrts for /boot
#echo "Rsyncing /boot into the filesystem." >&2;
#mkdir -p /boot.backup
#cmd="rsync -au --exclude 'efi' --delete /boot/ /boot.backup/"
#eval $cmd

set -e

echo "Rsyncing /boot/efi into the /boot/." >&2;
mkdir -p /boot/efi.backup
cmd="rsync -au --delete /boot/efi/ /boot/efi.backup"
eval $cmd
echo "Successfully rsynced /boot/efi into the /boot/." >&2;