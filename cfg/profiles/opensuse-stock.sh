#!/bin/bash
[ -e /mnt/boot/grub/entries/opensuse-stock.cfg ] && > /mnt/boot/grub/entries/opensuse-stock.cfg

for f in /mnt/boot/iso/opensuse-[1-99]*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/opensuse-stock.cfg <<_EOF_
if [ -e /boot/iso/opensuse-[1-99]*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/boot/x86_64/loader/linux install=hd:$isofile
	initrd (loop)/boot/x86_64/loader/initrd
    }
fi
_EOF_
done
