#!/bin/bash
[ -e /mnt/boot/grub/entries/centos.cfg ] && > /mnt/boot/grub/entries/centos.cfg

for f in /mnt/iso/centos*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}

# CentOS Live
cat >> /mnt/boot/grub/entries/centos.cfg <<_EOF_
if [ -f /iso/centos*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/isolinux/vmlinuz root="\$imgdevpath" iso-scan/filename=/iso/$iso rd.live.image
	initrd (loop)/isolinux/initrd.img
    }
fi
_EOF_
done
