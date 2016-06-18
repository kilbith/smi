#!/bin/bash
[ -e /mnt/boot/grub/entries/fedora-stock.cfg ] && > /mnt/boot/grub/entries/fedora-stock.cfg

for f in /mnt/boot/iso/fedora-[1-99]*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/fedora-stock.cfg <<_EOF_
if [ -e /boot/iso/fedora-[1-99]*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/isolinux/vmlinuz noeject inst.stage2=hd:"\$isodevpath":/boot/efi/$iso
	initrd (loop)/isolinux/initrd.img
    }
fi
_EOF_
done
