#!/bin/bash

set -eu

[[ "$EUID" -ne 0 ]] && echo "Please run as root." && exit 2

user=$(logname)
pool=rpool
zedtrigger=${pool}/home/${user}
restorecon=("/home" "/var/lib/libvirt")

operation=${1:-none}
disk=${2:-none}
partno=9

installZFS() {
  if ! rpm -q zfs >/dev/null; then
    rpm -e --nodeps zfs-fuse || true
    dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-5"$(rpm --eval "%{dist}")".noarch.rpm
    dnf -y install -y kernel-devel && dnf -y install zfs
    echo "zfs" | tee /etc/modules-load.d/zfs.conf >/dev/null
    echo "zfs" >/etc/dnf/protected.d/zfs.conf
  fi
  modprobe zfs
}

createPartition() {
  ! lsmod | grep -q zfs && echo "zfs module not loaded!" && exit 1

  [[ ! -L ${disk} ]] && echo "${disk} is not a valid disk device link!" && exit 1
  [[ -L ${disk}-part${partno} ]] && echo "${disk}-part${partno} already exists!" && exit 1

  mkdir -p /etc/zfs
  [[ ! -f "/etc/zfs/zfskey_${pool}_$(hostname)" ]] &&
    openssl rand -hex -out "/etc/zfs/zfskey_${pool}_$(hostname)" 32 &&
    chown root:root "/etc/zfs/zfskey_${pool}_$(hostname)" &&
    chmod 600 "/etc/zfs/zfskey_${pool}_$(hostname)"

  sgdisk --new=9:0:0 -c 9:"zfs ${pool}" -t 3:bf01 "$disk"
  partprobe
  sleep 2
  wipefs -a "$disk-part$partno"

  zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O encryption=aes-256-gcm \
    -O keylocation="file:///etc/zfs/zfskey_${pool}_$(hostname)" \
    -O keyformat=hex \
    -O acltype=posixacl \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O canmount=off \
    -O mountpoint=/ \
    -R /tmp/"$pool" \
    "$pool" \
    "$disk-part$partno"

  zfs create -p -o mountpoint=/home/"$user" "$pool/home/$user" &&
    sudo chown -R "$user:$user" /tmp/"$pool/home/$user"

  echo "ZFS Partition ${disk}-part${partno} created."
  echo "REMEMBER TO BACKUP /etc/zfs/zfskey_${pool}_$(hostname) somewhere very safe."
}

importPool() {
  ! lsmod | grep -q zfs && echo "zfs module not loaded!" && exit 1

  if ! zpool list -o name,health -H | grep -i -q "^${pool}.*ONLINE"; then
    zpool import "$pool"
  fi
  zpool set cachefile=/etc/zfs/zpool.cache "$pool"
  systemctl enable zfs-import-cache.service zfs-import.target
  mkdir -p /etc/zfs/zfs-list.cache
  systemctl enable --now zfs.target zfs-zed.service zfs-scrub-monthly@"$pool".timer
  [[ ! -e /etc/zfs/zfs-list.cache/${pool} ]] && touch /etc/zfs/zfs-list.cache/"$pool"

  zfs set canmount=off "$zedtrigger"
  zfs set canmount=on "$zedtrigger"

  if ! zfs get -o value -H keystatus "$pool" | grep -q "^available"; then
    zfs load-key -L "$(zfs get -o value -H keylocation "$pool")" "$pool"
  fi

  chown root:root "$(zfs get -o value -H keylocation "$pool" | sed -r 's/^file:\/\/(.*)$/\1/')"
  chmod 600 "$(zfs get -o value -H keylocation "$pool" | sed -r 's/^file:\/\/(.*)$/\1/')"

  echo "While logged in as root, do: "
  echo "rsync -vau /home/${user}/ /tmp/${pool}/home/${user}/"
  echo "rm -rf /home"
  echo "zpool export ${pool} && zpool import ${pool}"
  echo "zfs load-key -L file:///etc/zfs/zfskey_${pool}_$(hostname) ${pool}"
  echo "zfs mount -a"
  echo "(for RHEL/Fedora based distributions):"
  echo "for path in ${restorecon[@]}; do restorecon -R ${path}; done"
}

case ${operation} in
install)
  installZFS
  ;;
partcreate)
  [[ ${disk} == 'none' ]] && echo "Disk to perform operation on not supplied." && echo "usage: $0 partcreate /dev/disk/by-id/...." && exit 1
  createPartition
  ;;
importpool)
  importPool
  ;;
*)
  echo "Please invoke with install, partcreate or importpool."
  exit 1
  ;;
esac
