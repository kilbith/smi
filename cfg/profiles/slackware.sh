#!/bin/bash
[ -e /mnt/boot/grub/entries/slackware.cfg ] && > /mnt/boot/grub/entries/slackware.cfg

for f in /mnt/boot/iso/slackware*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/slackware.cfg <<_EOF_
if [ -e /boot/iso/slackware*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/isolinux/rescue64 isoloop=$isofile
	initrd (loop)/isolinux/initram.igz
    }
fi
_EOF_
done
