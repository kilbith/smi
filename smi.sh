#!/bin/bash

exit_error() {
    local prefix="<3>" suffix=""
    if [[ -t 2 ]]; then
	prefix=$(tput bold; tput setaf 1)
	suffix=$(tput sgr0)
    fi
    printf "$prefix$*$suffix\n" >&2
    exit 0
}

if ! type pv &> /dev/null; then
    exit_error "Please install 'pv' to use this installer"
fi

ensure_root() {
    (( EUID == 0 )) || exit_error "${1-$0} needs root privileges"
}
ensure_root "$(basename "$0")"

msgbox() {
    whiptail --msgbox "${1}" 8 50
}

install_grub() {
    ENTRIES=$(whiptail --title "Select GRUB mode for /dev/"$DRIVE"1" --menu "" 15 50 8 \
	1 "BIOS" \
	2 "EFI" \
	"" "" \
	B "Back to options" \
	Q "Quit" \
	3>&2 2>&1 1>&3)

    case $ENTRIES in
	1) grub="--target=i386-pc /dev/$DRIVE";;
	2) grub="--target=x86_64-efi --efi-directory=/mnt";;
	B) menu_options;;
	Q) exit 0;;
	*) install_grub;;
    esac

    COMMANDS=(
	"umount -l /dev/$DRIVE?*"
	"dd if=/dev/zero of=/dev/$DRIVE bs=512 count=1 conv=notrunc"
	"echo -e 'o\nn\np\n1\n\n\nw' | fdisk /dev/$DRIVE"
	"mkfs.vfat -F32 /dev/"$DRIVE"1"
	"mount -t vfat /dev/"$DRIVE"1 /mnt"
	"grub-install $grub --boot-directory=/mnt/boot --removable"
	"mkdir -p /mnt/boot/iso"
	"mkdir -p /mnt/boot/grub/entries"
	"cp cfg/grub.cfg /mnt/boot/grub/"
	"umount /mnt"
	"eject -t /dev/$DRIVE"
    )

    { c=0; for cmd in "${COMMANDS[@]}"; do
	       eval ${cmd} &> /dev/null
	       sleep 0.1
	       (( c+=100/${#COMMANDS[@]} ))
	       echo $c
           done
    } | whiptail --gauge "Installing GRUB on /dev/"$DRIVE"1. Please wait..." 8 50 0

    msgbox "GRUB successfully installed on /dev/"$DRIVE"1." 8 50
    menu_options
}

install_iso() {
    if $(ls -A iso) &> /dev/null; then
	msgbox "No image found in the iso/ directory."
	menu_options
    fi

    for f in iso/*.iso; do
	f_lower=${f,,}
	[[ "$f" =~ " " ]] && mv "$f" `echo $f | tr " " "-"` &> /dev/null
	[[ "$f" =~ [[:upper:]] ]] && mv "$f" `echo $f_lower` &> /dev/null
    done

    list=(B "Back to options" Q "Quit" "" ""); i=0
    for f in iso/*.iso; do
	i=$(($i+1))
	list+=("$i" "${f:4:40} ")
    done

    ENTRIES=$(whiptail --title "Select an image to install on /dev/"$DRIVE"1" \
	--menu "" 15 50 8 "${list[@]}" 3>&2 2>&1 1>&3)
    ISOS=(iso/*.iso)
    ISO=${ISOS[$ENTRIES-1]:4}
    iso_name=${ISO::-4}
    iso_name=${iso_name%%[-_]*}
    iso_title=${iso_name^}

    umounting() {
	umount /mnt
	eject -t /dev/$DRIVE
    }

    check_device() {
	if ! grep -q ${iso_name:1} cfg/profiles/*; then
	    msgbox "No configuration profile(s) found for $iso. Please create one in the cfg/profiles/ directory."
	    install_iso
	fi
	grep -q /dev/$DRIVE /proc/mounts && umount -l /dev/$DRIVE?*

	part_type=$(lsblk -f /dev/"$DRIVE"1 | tail -1 | awk '{print $2}')
	if [ "$part_type" = "vfat" ]; then
	    mount -t vfat /dev/"$DRIVE"1 /mnt &> /dev/null
	else
	    msgbox "/dev/"$DRIVE"1 has no FAT file system."
	    menu_options
	fi
	if [ ! -d /mnt/boot/grub ]; then
	    umounting
	    msgbox "GRUB is not installed on /dev/"$DRIVE"1."
	    menu_options
	fi

	iso_size=$(stat --printf="%s" iso/$ISO)
	free_space=$(df -B1 /mnt | tail -1 | awk '{print $4}')
	if [ "$iso_size" -gt "$free_space" ]; then
	    umounting
	    msgbox "Not enough space on /dev/"$DRIVE"1 for installing $ISO."
	    menu_options
	fi
    }

    create_profile() {
	[[ $iso_name == "archlinux"*       ]] && source cfg/profiles/archlinux.sh
	[[ $iso_name == "centos-[1-99]"*   ]] && source cfg/profiles/centos-stock.sh
	[[ $iso_name == "centos"*"live"*   ]] && source cfg/profiles/centos-live.sh
	[[ $iso_name == "debian-[1-99]"*   ]] && source cfg/profiles/debian-stock.sh
	[[ $iso_name == "debian-live"*     ]] && source cfg/profiles/debian-live.sh
	[[ $iso_name == "fedora-[1-99]"*   ]] && source cfg/profiles/fedora-stock.sh
	[[ $iso_name == "fedora-live"*     ]] && source cfg/profiles/fedora-live.sh
	[[ $iso_name == "gentoo"*          ]] && source cfg/profiles/gentoo.sh
	[[ $iso_name == "linuxmint"*       ]] && source cfg/profiles/linuxmint.sh
	[[ $iso_name == "opensuse-[1-99]"* ]] && source cfg/profiles/opensuse-stock.sh
	[[ $iso_name == "opensuse"*"live"* ]] && source cfg/profiles/opensuse-live.sh
	[[ $iso_name == "slackware"*       ]] && source cfg/profiles/slackware.sh
	[[ $iso_name == *"ubuntu"*"i386"   ]] && source cfg/profiles/ubuntu32.sh
	[[ $iso_name == *"ubuntu"*"amd64"  ]] && source cfg/profiles/ubuntu64.sh
    }

    copy_files() {
	{ (pv -n iso/$ISO > /mnt/boot/iso/$ISO) 3>&2 2>&1 1>&3
	  create_profile
	  umounting
	} | whiptail --gauge "Installing $iso_title on /dev/"$DRIVE"1. Please wait..." 8 50 0

	msgbox "$ISO successfully installed on /dev/"$DRIVE"1."
    }

    case "${ENTRIES}" in
	B) menu_options;;
	Q) exit 0;;
 	([1-9]|[1-7][0-9]|30) check_device; copy_files; install_iso;;
	*) install_iso;;
    esac
}

menu_options() {
    ENTRIES=$(whiptail --title "Choose an operation for /dev/$DRIVE" --menu "" 15 50 8 \
	1 "Install GRUB" \
	2 "Install ISO image(s)" \
	"" "" \
	B "Back to device list" \
	Q "Quit" \
	3>&2 2>&1 1>&3)

    case "${ENTRIES}" in
	B) list_devices;;
	Q) exit 0;;
	1) install_grub;;
        2) install_iso;;
	*) menu_options;;
    esac
}

list_devices() {
    DEVICES=($(
	grep -Hv ^ATA\ *$ /sys/block/*/device/vendor |
	sed s/device.vendor:.*$/device\\/uevent/ |
	xargs grep -H ^DRIVER=sd |
	sed s/device.uevent.*$/size/ |
	xargs grep -Hv ^0$ |
	cut -d / -f 4
    ))

    if [ ${#DEVICES[@]} -eq 0 ]; then
	title="No USB device found"
    else
	title="Select USB device"
    fi

    list=()
    for dev in ${DEVICES[@]}; do
	read model < /sys/block/$dev/device/model
	printf -v desc "%8s %s" "$model"
	list+=($dev "$desc")
    done
    list+=("" "" R "Re-scan devices" Q "Quit")

    ENTRIES=$(whiptail --title "$title" --menu "" 15 50 0 "${list[@]}" 3>&2 2>&1 1>&3)
    case "${ENTRIES}" in
	R) list_devices;;
	Q) exit 0;;
        [sd]*) DRIVE=$ENTRIES; menu_options;;
	*) list_devices;;
    esac
}

list_devices

