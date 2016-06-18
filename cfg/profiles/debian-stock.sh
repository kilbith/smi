#!/bin/bash
[ -e /mnt/boot/grub/entries/debian-stock.cfg ] && > /mnt/boot/grub/entries/debian-stock.cfg

for f in /mnt/boot/iso/debian-[1-99]*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/debian-stock.cfg <<_EOF_
if [ -e /boot/iso/debian-[1-99]*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/install.amd/vmlinuz vga=791 iso-scan/ask_second_pass=true iso-scan/filename=/boot/iso/$iso
	initrd /boot/iso/$iso.hdd.initrd.gz
    }
fi
_EOF_
done
