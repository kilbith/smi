#!/bin/bash
[ -e /mnt/boot/grub/entries/fedora-live.cfg ] && > /mnt/boot/grub/entries/fedora-live.cfg

for f in /mnt/boot/iso/fedora-live*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/fedora-live.cfg <<_EOF_
if [ -e /boot/iso/fedora-live*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/isolinux/vmlinuz0 root="\$isodevpath" iso-scan/filename=$iso rd.live.image
	initrd (loop)/isolinux/initrd0.img
    }
fi
_EOF_
done
