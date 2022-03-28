#!/bin/bash

# openSUSE first boot preparations

POOL=dpool

if ! zypper lr | grep -q packman; then
  sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
fi
if ! zypper lr | grep -q filesystems; then
  sudo zypper ar https://download.opensuse.org/repositories/filesystems/openSUSE_Tumbleweed/filesystems.repo
fi
sudo zypper refresh && sudo zypper dup -y

sudo zypper --gpg-auto-import-keys dup -y --allow-vendor-change --from packman
sudo zypper --gpg-auto-import-keys in -y zfs
sudo modprobe zfs

sudo systemctl enable --now zfs-import-cache.service zfs-zed.service zfs-import.target zfs.target
[[ ! -d /etc/zfs/zfs-list.cache ]] && sudo mkdir -p /etc/zfs/zfs-list.cache
[[ ! -e /etc/zfs/zfs-list.cache/${POOL} ]] && sudo touch /etc/zfs/zfs-list.cache/"$POOL"

if sudo zpool import 2>/dev/null | grep -q "$POOL.*ONLINE"; then
  sudo zpool import "$POOL"
  sudo zpool set cachefile=/etc/zfs/zpool.cache "$POOL"
  dataset=$(sudo zfs list -H "$POOL" | tail -1 | awk '{print $1}')
  sudo zfs set canmount=off "$dataset"
  sleep 2
  sudo zfs set canmount=on "$dataset"
fi
