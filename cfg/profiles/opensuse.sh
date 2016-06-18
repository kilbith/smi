#!/bin/bash
[ -e /mnt/boot/grub/entries/opensuse.cfg ] && > /mnt/boot/grub/entries/opensuse.cfg

for f in /mnt/iso/opensuse*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}

# OpenSUSE Live
cat >> /mnt/boot/grub/entries/opensuse.cfg <<_EOF_
if [ -f /iso/opensuse*live*.iso ]; then
    menuentry "$isoname" {
	loopback loop /iso/$iso
	linux (loop)/boot/x86_64/loader/linux isofrom_device="\$imgdevpath" isofrom_system=/iso/$iso LANG=en_US.UTF-8
	initrd (loop)/boot/x86_64/loader/initrd
    }
fi
_EOF_
done
