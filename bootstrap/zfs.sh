#!/bin/bash

set -e

[[ "$EUID" -ne 0 ]] && echo "Please run as root." && exit 2

user=$(logname)
pool=rpool
zedtrigger="${pool}/home"
restorecon=("/home")

operation=${1:-none}
disk=${2:-none}
partno=9
myHostname=$(hostnamectl hostname)

installZFS() {
  if grep -q "ID=arch" /etc/os-release; then
    echo "Install not needed under Arch. Use cachyos kernel."
    exit 1
  elif grep -q "ID=fedora" /etc/os-release; then
    if ! rpm -q zfs >/dev/null; then
      rpm -e --nodeps zfs-fuse || true
      dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-5"$(rpm --eval "%{dist}")".noarch.rpm
      dnf -y install -y kernel-devel && dnf -y install zfs
      echo "zfs" | tee /etc/modules-load.d/zfs.conf >/dev/null
      echo "zfs" >/etc/dnf/protected.d/zfs.conf
      modprobe zfs
    fi
  else
    echo "Unsupported distribution."
    exit 1
  fi
}

createPartition() {
  ! lsmod | grep -q zfs && echo "zfs module not loaded!" && exit 1

  if ! command -v sgdisk &>/dev/null; then
    if grep -q "ID=arch" /etc/os-release; then
      pacman -S --noconfirm --needed gptfdisk
    elif grep -q "ID=fedora" /etc/os-release; then
      dnf install -y gdisk
    fi
  fi

  [[ ! -L ${disk} ]] && echo "${disk} is not a valid disk device link!" && exit 1
  [[ -L ${disk}-part${partno} ]] && echo "${disk}-part${partno} already exists!" && exit 1

  mkdir -p /etc/zfs
  [[ ! -f "/etc/zfs/zfskey_${pool}_${myHostname}" ]] &&
    openssl rand -hex -out "/etc/zfs/zfskey_${pool}_${myHostname}" 32 &&
    chown root:root "/etc/zfs/zfskey_${pool}_${myHostname}" &&
    chmod 600 "/etc/zfs/zfskey_${pool}_${myHostname}"

  sgdisk --new="$partno":0:0 -c "$partno:zfs ${pool}" -t "$partno":bf01 "$disk"
  partprobe
  sleep 2
  wipefs -a "$disk-part$partno"

  zpool create \
    -o ashift=12 \
    -o autotrim=on \
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

  zfs create -o mountpoint=none \
    -o encryption=aes-256-gcm \
    -o keylocation="file:///etc/zfs/zfskey_${pool}_${myHostname}" \
    -o keyformat=hex "${pool}/local"
  zfs create -o mountpoint=/home "${pool}/local/home"
  zfs create -p -o mountpoint=/home/"$user" "$pool/local/home/$user" &&
    sudo chown -R "$user:$user" /tmp/"$pool/home/$user"

  echo "ZFS Partition ${disk}-part${partno} created."
  echo
  echo "REMEMBER TO BACKUP /etc/zfs/zfskey_${pool}_${myHostname} somewhere very safe."

  echo "If you need to move your existing $HOME over to the new ZFS pool..."
  echo
  echo "While logged in as root, do: "
  echo "rsync -vau /home/${user}/ /tmp/${pool}/home/${user}/"
  echo "rm -rf /home"
  echo "zpool export ${pool} && zpool import ${pool}"
  echo "zfs load-key -L file:///etc/zfs/zfskey_${pool}_${myHostname} ${pool}"
  echo "zfs mount -a"
  echo
  echo "For RHEL/Fedora based distributions also needed:"
  for path in "${restorecon[@]}"; do
    echo "restorecon -R ${path}"
  done
  echo
  echo "Afterwards execute..."
  echo "zfs umount -a && zfs export ${pool}"
  echo "$0 importpool"
  echo "If you are on arch and using aconfmgr, you might need to a 'aconfmgr apply' to apply existing ZFS configurations that might have been skipped beforehand"
  echo "... and reboot"
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
  echo "If you are on arch and using aconfmgr, you might need to a 'aconfmgr apply' to apply existing ZFS configurations that might have been skipped beforehand"
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
