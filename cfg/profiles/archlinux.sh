#!/bin/bash
[ -e /mnt/boot/grub/entries/archlinux.cfg ] && > /mnt/boot/grub/entries/archlinux.cfg

for f in /mnt/boot/iso/archlinux*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/archlinux.cfg <<_EOF_
if [ -e /boot/iso/archlinux*.iso ]; then
    loopback loop /boot/iso/$iso
    menuentry "$isoname (32 bits)" {
	linux (loop)/arch/boot/i686/vmlinuz img_dev="\$imgdevpath" img_loop=/boot/iso/$iso earlymodules=loop
	initrd (loop)/arch/boot/i686/archiso.img
    }
    menuentry "$isoname (64 bits)" {
	linux (loop)/arch/boot/x86_64/vmlinuz img_dev="\$imgdevpath" img_loop=/boot/iso/$iso earlymodules=loop
	initrd (loop)/arch/boot/x86_64/archiso.img
    }
fi
_EOF_
done
