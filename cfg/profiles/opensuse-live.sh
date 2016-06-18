#!/bin/bash
[ -e /mnt/boot/grub/entries/opensuse-live.cfg ] && > /mnt/boot/grub/entries/opensuse-live.cfg

for f in /mnt/boot/iso/opensuse*live*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/opensuse-live.cfg <<_EOF_
if [ -e /boot/iso/opensuse*live*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/boot/x86_64/loader/linux install=hd:$isofile
	initrd (loop)/boot/x86_64/loader/initrd
    }
fi
_EOF_
done
