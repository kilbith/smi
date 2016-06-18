#!/bin/bash
[ -e /mnt/boot/grub/entries/centos-stock.cfg ] && > /mnt/boot/grub/entries/centos-stock.cfg

for f in /mnt/boot/iso/centos-[1-99]*.iso; do
    iso=${f##*/}
    isoname=${iso::-4}
cat >> /mnt/boot/grub/entries/centos-stock.cfg <<_EOF_
if [ -e /boot/iso/centos-[1-99]*.iso ]; then
    menuentry "$isoname" {
	loopback loop /boot/iso/$iso
	linux (loop)/isolinux/vmlinuz0 root="\$isodevpath" iso-scan/filename=$iso rd.live.image
	initrd (loop)/isolinux/initrd0.img
    }
fi
_EOF_
done
