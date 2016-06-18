#!/bin/bash
[ -e /mnt/boot/grub/entries/ubuntu64.cfg ] && > /mnt/boot/grub/entries/ubuntu64.cfg

for f in /mnt/boot/iso/*ubuntu*amd64.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/ubuntu64.cfg <<_EOF_
if [ -e /boot/iso/*ubuntu*amd64.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/casper/vmlinuz.efi boot=casper iso-scan/filename=/boot/iso/$iso quiet splash --
	initrd (loop)/casper/initrd.lz
    }
fi
_EOF_
done
