SMI - Simple Multiboot Integrator
=================================

http://github.com/kilbith/smi

Description
-----------

SMI is a fast and effortless semi-GUI integrator to create a USB stick with
several bootable GNU/Linux distributions. SMI manages the installation
of GRUB and the ISO images of your favorite distributions.

Screenshots
-----------

![Screenshots](https://lut.im/e2As3L8Tc3/YnxRFj4wXD9uvKUM.gif)

Installation
------------

You will need three dependencies :

  * GRUB2 (usually installed on most distributions)
  * pv
  * whiptail (packaged in the `newt` library, that NetworkManager uses)

Download the archive :

    git clone https://github.com/kilbith/smi.git

Move some ISO images in the `smi/iso/` directory.
Note : you need to install GRUB first on your USB stick before installing the ISO images.

Then, run the installer :

    cd smi
    sudo ./smi

Once GRUB and some ISO image(s) are installed on your USB drive, reboot your system,
boot on your USB drive and select a bootable distribution in the GRUB menu.

The supported GNU/Linux distributions currently are :

  * Arch Linux
  * CentOS
  * Debian
  * Fedora
  * Gentoo
  * Linux Mint
  * OpenSUSE
  * Slackware
  * Ubuntu and all its derivatives

Troubleshooting
---------------

Some GRUB configuration files might be incorrect currently or in the future.
Please consult the [Arch Linux's wiki page](https://wiki.archlinux.org/index.php/Multiboot_USB_drive)
for more details about the GRUB configurations or adding support for more distributions.

Don't hesitate to [open an issue](https://github.com/kilbith/smi/issues/new) for feedbacks and bug reports.

