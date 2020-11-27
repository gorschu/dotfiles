#!/bin/zsh

# to burn a CD ISO:
# cdrecord -v -sao dev=/dev/sr0 image.iso
#
# to burn a DVD/Bluray ISO:
# growisofs -dvd-compat -Z /dev/sr0=isoimage.iso
#
# to burn a AudioCD bin/toc:
# cdrdao write --device /dev/sr0 image.toc

if [[ -n "$1" ]]; then
    name=$1
else
    name=image
fi

if isosize /dev/sr0 2> /dev/null; then
    blocks=$(isosize -d 2048 /dev/sr0)
    echo "CDROM has ${blocks} blocks. That would be "$(($blocks/512))" MB."
    dd if=/dev/sr0 of=${name}.iso status=progress bs=2048 count="$blocks"
else
    if cat /proc/mounts | egrep "^/dev/sr0"; then
        sudo umount /dev/sr0
    fi
    cdrdao read-cd --with-cddb --read-raw --datafile ${name}.bin ${name}.toc
fi
