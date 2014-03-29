#!/bin/bash

# Create directories required for pxe bootloader
mkdir -p /tftpboot/{linux,pxelinux.cfg}

# Copy PXE boot loader (comes with syslinux package)
cp /usr/lib/syslinux/pxelinux.0 /tftpboot/
 
# Copy linux kernel so it can be passed onto nodes by a pxe bootloader
cp /boot/vmlinuz-$(uname -r) /tftpboot/linux
 
# Copy linux root filesystem image
cp rootfs.gz /tftpboot/linux

# Change permission
chmod -R 755 /tftpboot
