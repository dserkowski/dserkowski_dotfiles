# References
https://theduckchannel.github.io/post/2021/08/24/install-ubuntu-21.04-with-btrfs-+-snapper-+-grub-btrfs/
https://mutschler.dev/linux/ubuntu-btrfs-20-04/


# Howto
1. create subvolumes for directories that should not be backed up (live CD is needed - system files)


    ```
    mv ~/.cache ~/.cache-old
    btrfs subvolume create .cache
    chown --reference=.cache-old .cache
    chmod --reference=.cache-old .cache
    mv .cache-old/* .cache
    rm -r .cache-old/
    ```

    run it for (omit those that doesn't exist)
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

1. (optional) run system from live CD and create @snapshots subvolume
    ```
    sudo -i
    mount -o defaults,ssd,noatime,compress=zstd:2 /dev/mapper/rootfs /mnt
    btrfs subvolume create @snapshots
    reboot
    ```

1. install snapper and grub-btrfs using `optional/install.sh`
1. configure snapper
    ```
    sudo snapper create-config / # has to be without name
    sudo snapper -c home create-config /home
    sudo snapper -c boot create-config /boot

    # enter config files and configure:
    # set ALLOW_USERS="your_username_here"
    # set max snapshots - timeline
    sudo vim /etc/snapper/configs/root
    sudo vim /etc/snapper/configs/home
    sudo vim /etc/snapper/configs/boot

    # example:
    # NUMBER_LIMIT="2"
    # NUMBER_LIMIT_IMPORTANT="1"

    # TIMELINE_LIMIT_HOURLY="5"
    # TIMELINE_LIMIT_DAILY="7"
    # TIMELINE_LIMIT_WEEKLY="1"
    # TIMELINE_LIMIT_MONTHLY="1"
    # TIMELINE_LIMIT_YEARLY="0"
    ```
1. (optional) mount @snapshot

    sudo rm -Rf /.snapshots
    sudo rm -Rf /home/.snapshots
    sudo mkdir /.snapshots
    sudo mkdir /home/.snapshots
    sudo chmod 750 /.snapshots
    sudo chmod 750 /home/.snapshots
    sudo chmod 750 /boot/.snapshots

    # configure @snapshot to be mounted as .snapshots 
    sudo vim /etc/fstab
    sudo mount -av # should be successfull
    ```
3. enable services
    ```
    sudo systemctl enable --now snapper-timeline.timer
    sudo systemctl enable --now snapper-cleanup.timer
    sudo systemctl enable --now grub-btrfs.path
    ```
4. (Optional) apt integation (create /, /boot and /boot/efi backups on every apt operation)
    ```
    cd backup-apt-integration
    ./install.sh
    ```