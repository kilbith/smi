SMI - Simple Multiboot Installer
================================

http://github.com/kilbith/smi

Description
-----------

SMI is a fast and effortless semi-GUI installer and a set of GRUB configuration
files to create a neat USB stick with several multi-bootable GNU/Linux distributions.

Screenshots
-----------

![Screenshots](https://lut.im/e2As3L8Tc3/YnxRFj4wXD9uvKUM.gif)

Installation
------------

You will need to install two dependencies :

  * GRUB2 (installed on most distributions)
  * pv

Download the archive :

    git clone https://github.com/kilbith/smi.git

Alternatively if you don't have `git` installed :

    wget https://github.com/kilbith/smi/archive/master.tar.gz
    tar -xvf master.tar.gz

Then all you need to do is the following :

    cd smi
    sudo ./smi.sh

... and the installation begins in your terminal.

The supported GNU/Linux distributions currently are :

  * Arch Linux
  * CentOS
  * Debian
  * Fedora
  * Gentoo
  * Linux Mint
  * OpenSUSE
  * Slackware
  * Ubuntu
  * Kubuntu
  * Xubuntu
  * Lubuntu

Troubleshooting
---------------

Some GRUB configuration files might be incorrect currently or in the future.
Please consult the [Arch Linux's wiki page](https://wiki.archlinux.org/index.php/Multiboot_USB_drive) to configure the templates,
or add the support of more distributions.

