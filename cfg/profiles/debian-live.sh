#!/bin/bash
[ -e /mnt/boot/grub/entries/debian-live.cfg ] && > /mnt/boot/grub/entries/debian-live.cfg

for f in /mnt/boot/iso/debian-live*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/debian-live.cfg <<_EOF_
if [ -e /boot/iso/debian-live*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/live/vmlinuz boot=live config fromiso="\$imgdevpath/$iso" components quiet splash
	initrd (loop)/live/initrd.img
    }
fi
_EOF_
done
