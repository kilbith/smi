#!/bin/bash
[ -e /mnt/boot/grub/entries/slackware.cfg ] && > /mnt/boot/grub/entries/slackware.cfg

for f in /mnt/iso/slackware*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/slackware.cfg <<_EOF_
if [ -f /iso/slackware*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/isolinux/rescue64 isoloop=$isofile
	initrd (loop)/isolinux/initram.igz
    }
fi
_EOF_
done
