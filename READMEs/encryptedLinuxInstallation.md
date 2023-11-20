# References
* base: https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019 - I omitted LVM configuration
* extra explaination: https://mutschler.dev/linux/ubuntu-btrfs-20-04/ 
* also https://theduckchannel.github.io/post/2021/08/24/install-ubuntu-21.04-with-btrfs-+-snapper-+-grub-btrfs/

Notes
* give /boot partition more space for backups 2-3GB in total
* give slight more spaces between partition - for easier modifications in the future
* my crypt fs tab settings:

/etc/crypttab
```
rootfs UUID=fff83c1a-3128-4463-85b7-492ac0fb6f47 /etc/luks/boot_os.keyfile luks,discard
boot UUID=b2ec886e-620d-4e2b-8f0e-a7fa4f36db23 /etc/luks/boot_os.keyfile luks,discard
swap UUID=1183b7a4-d61c-4306-b7f6-14e953448446 /dev/urandom swap,cipher=aes-xts-plain64,size=512,offset=2048
```

/etc/fstab
```
/dev/mapper/rootfs  /home            btrfs   defaults,subvol=@home,ssd,noatime,commit=120,compress=zstd:2         0       0
/dev/mapper/rootfs  /                btrfs   defaults,subvol=@,ssd,noatime,commit=120,compress=zstd:2             0       0
/dev/mapper/rootfs  /.snapshots      btrfs   defaults,subvol=@snapshots,ssd,noatime,commit=120,compress=zstd:2    0       0
/dev/mapper/rootfs  /home/.snapshots btrfs   defaults,subvol=@snapshots,ssd,noatime,commit=120,compress=zstd:2    0       0
/dev/mapper/boot    /boot            btrfs   defaults,subvol=/,ssd,noatime,commit=120,compress=zstd:2             0       0
UUID=934C-DB66      /boot/efi        vfat    umask=0077      0       1
/dev/mapper/swap    none             swap    sw              0       0
tmpfs               /tmp             tmpfs   defaults,noatime,nosuid,nodev,noexec,mode=1777,size=2G 0 0
```
* reducing GRUB selection timeout
```
sudo vim /etc/default/grub
# change GRUB_TIMEOUT=X
# and for btrfs define GRUB_RECORDFAIL_TIMEOUT=X 
# due to https://askubuntu.com/a/1123295

sudo update-grub

cat /boot/grub/grub.cfg | grep timeout # to check if changes were propagated well
```