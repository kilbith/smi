#!/bin/bash
[ -e /mnt/boot/grub/entries/linuxmint.cfg ] && > /mnt/boot/grub/entries/linuxmint.cfg

for f in /mnt/boot/iso/linuxmint*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/linuxmint.cfg <<_EOF_
if [ -e /boot/iso/linuxmint*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$iso noeject noprompt 
	initrd (loop)/casper/initrd.lz
    }
fi
_EOF_
done
