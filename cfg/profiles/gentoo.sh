#!/bin/bash
[ -e /mnt/boot/grub/entries/gentoo.cfg ] && > /mnt/boot/grub/entries/gentoo.cfg

for f in /mnt/iso/gentoo*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/gentoo.cfg <<_EOF_
if [ -f /iso/gentoo*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/isolinux/gentoo root="\$imgdevpath" init=/linuxrc aufs looptype=squashfs loop=/image.squashfs cdroot isoboot=/iso/$iso vga=791 splash=silent,theme:default console=tty0
	initrd (loop)/isolinux/gentoo.xz 
    }
fi
_EOF_
done
