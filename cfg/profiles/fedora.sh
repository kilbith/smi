#!/bin/bash
[ -e /mnt/boot/grub/entries/fedora.cfg ] && > /mnt/boot/grub/entries/fedora.cfg

for f in /mnt/iso/fedora*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}

# Fedora Live
cat >> /mnt/boot/grub/entries/fedora.cfg <<_EOF_
if [ -f /iso/fedora*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/isolinux/vmlinuz root="\$imgdevpath" iso-scan/filename=/iso/$iso rd.live.image quiet
	initrd (loop)/isolinux/initrd.img
    }
fi
_EOF_
done
