#!/bin/bash
[ -e /mnt/boot/grub/entries/debian.cfg ] && > /mnt/boot/grub/entries/debian.cfg

for f in /mnt/iso/debian*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}

# Debian Live
cat >> /mnt/boot/grub/entries/debian.cfg <<_EOF_
if [ -f /iso/debian-live*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/live/vmlinuz boot=live config findiso=/iso/$iso components quiet splash
	initrd (loop)/live/initrd.img
    }
fi
_EOF_
done
