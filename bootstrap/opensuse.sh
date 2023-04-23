#!/bin/bash

# openSUSE first boot preparations

set -euo pipefail

POOL=dpool
zedtrigger=dpool/libvirt

if ! zypper lr | grep -q filesystems; then
  sudo zypper ar --refresh https://download.opensuse.org/repositories/filesystems/openSUSE_Tumbleweed/filesystems.repo
  sudo zypper refresh && sudo zypper dup -y
fi

if ! rpm -q zfs > /dev/null; then
  sudo zypper --gpg-auto-import-keys in -y zfs
fi
sudo modprobe zfs

if ! sudo zpool list -o name,health -H | grep -i -q "^${POOL}.*ONLINE"; then
  sudo zpool import ${POOL}
fi
sudo zpool set cachefile=/etc/zfs/zpool.cache ${POOL}
sudo systemctl enable zfs-import-cache.service zfs-import.target
sudo mkdir -p /etc/zfs/zfs-list.cache
sudo systemctl enable --now zfs.target zfs-zed.service zfs-scrub-monthly@${POOL}.timer
[[ ! -e /etc/zfs/zfs-list.cache/${POOL} ]] && sudo touch /etc/zfs/zfs-list.cache/${POOL}

sudo zfs set canmount=off ${zedtrigger}
sudo zfs set canmount=on ${zedtrigger}

if ! sudo zfs get -o value -H keystatus ${POOL} | grep -q "^available"; then
  sudo zfs load-key -L "$(zfs get -o value -H keylocation ${POOL})" ${POOL}
fi
sudo chown root:root "$(zfs get -o value -H keylocation ${POOL} | sed -r 's/^file:\/\/(.*)$/\1/')"
sudo chmod 600 "$(zfs get -o value -H keylocation ${POOL} | sed -r 's/^file:\/\/(.*)$/\1/')"
