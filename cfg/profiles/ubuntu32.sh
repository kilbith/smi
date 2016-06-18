#!/bin/bash
[ -e /mnt/boot/grub/entries/ubuntu32.cfg ] && > /mnt/boot/grub/entries/ubuntu32.cfg

for f in /mnt/boot/iso/*ubuntu*i386.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/ubuntu32.cfg <<_EOF_
if [ -e /boot/iso/*ubuntu*i386.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/boot/iso/$iso quiet splash --
	initrd (loop)/casper/initrd.lz
    }
fi
_EOF_
done
