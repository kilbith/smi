#!/bin/bash
[ -e /mnt/boot/grub/entries/archlinux.cfg ] && > /mnt/boot/grub/entries/archlinux.cfg

for f in /mnt/iso/archlinux*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/archlinux.cfg <<_EOF_
if [ -f /iso/archlinux*.iso ]; then
    loopback loop /iso/$iso
    menuentry "$isoname" {
	linux (loop)/arch/boot/x86_64/vmlinuz img_dev="\$imgdevpath" img_loop=/iso/$iso earlymodules=loop
	initrd (loop)/arch/boot/x86_64/archiso.img
    }
fi
_EOF_
done
