# References
* base: https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019 - I omitted LVM configuration
* extra explaination: https://mutschler.dev/linux/ubuntu-btrfs-20-04/ 


* my settings that works

/etc/crypttab
```
rootfs UUID=fff83c1a-3128-4463-85b7-492ac0fb6f47 /etc/luks/boot_os.keyfile luks,discard
boot UUID=b2ec886e-620d-4e2b-8f0e-a7fa4f36db23 /etc/luks/boot_os.keyfile luks,discard
swap UUID=1183b7a4-d61c-4306-b7f6-14e953448446 /dev/urandom swap,cipher=aes-xts-plain64,size=512,offset=2048
```

/etc/fstab
```
/dev/mapper/rootfs  /home           btrfs   defaults,subvol=@home,ssd,noatime,commit=120,compress=zstd:2 0       0
/dev/mapper/rootfs  /               btrfs   defaults,subvol=@,ssd,noatime,commit=120,compress=zstd:2     0       0
/dev/mapper/boot    /boot           btrfs   defaults,subvol=/,ssd,noatime,commit=120,compress=zstd:2     0       0
UUID=934C-DB66      /boot/efi       vfat    umask=0077      0       1
/dev/mapper/swap    none            swap    sw              0       0
```