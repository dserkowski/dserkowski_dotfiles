# References
https://theduckchannel.github.io/post/2021/08/24/install-ubuntu-21.04-with-btrfs-+-snapper-+-grub-btrfs/
https://mutschler.dev/linux/ubuntu-btrfs-20-04/


# Howto
1. create subvolumes for directories that should not be backed up (live CD is needed)

a. for data without CoW
```
mv ~/.cache ~/.cache-old
btrfs subvolume create .cache
chattr +C .cache
mv .cache-old/* .cache
rm -r .cache-old/
```
generally, this is not recommended and it such cases you should rather consider using ext4 instead

b. for other cases:
```
mv ~/.cache ~/.cache-old
btrfs subvolume create .cache
chattr +C .cache
mv .cache-old/* .cache
rm -r .cache-old/
```

run it for 
* /tmp (if it is not mount as tmpfs)
* /var/cache, 
* /var/abs, 
* /srv, 
* /var/tmp, 
* /var/spool, 
* /var/lib/machines, 
* /var/lib/docker, 
* /home/<user>/.cache, 
* /home/<user>/repos

1. install and configure timeshift
```
sudo apt install -y btrfs-progs git make &&
sudo apt install timeshift &&
sudo timeshift-gtk
```
Note: that it can only backs up / and /home. For more complicated cases you need to use snapper.

1. install extensions triggering doing backup before `apt` executions and `/boot` partition

