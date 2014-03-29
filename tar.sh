#!/bin/bash
gzip -c rootfs | dd of=rootfs.gz
chmod 755 rootfs.gz

# Create symbolic link of linux root filesystem image
cp rootfs.gz /tftpboot/linux/
