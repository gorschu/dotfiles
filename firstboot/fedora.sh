#!/bin/bash

set -eux

POOL=dpool
zedtrigger=dpool/libvirt
restorecon=("/home" "/var/lib/libvirt")

if ! rpm -q zfs >/dev/null; then
  sudo dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-2$(rpm --eval "%{dist}").noarch.rpm
  sudo dnf -y install -y kernel-devel && sudo dnf swap -y zfs-fuse zfs
  echo "zfs" | sudo tee /etc/modules-load.d/zfs.conf >/dev/null
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

echo "While logged in as root, do: "
echo "sudo zfs mount -a"
echo 'for path in "${restorecon[@]}"; do sudo restorecon -R "${path}"; done'
