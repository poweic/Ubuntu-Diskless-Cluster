#!/bin/bash
gzip -c rootfs | dd of=rootfs.gz
chmod 755 rootfs.gz

# Create symbolic link of linux root filesystem image
ln -sf $(pwd)/rootfs.gz /tftpboot/linux/rootfs.gz
