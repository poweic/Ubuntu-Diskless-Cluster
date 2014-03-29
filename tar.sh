#!/bin/bash
gzip -c rootfs | dd of=rootfs.gz

# copy linux root filesystem image
cp rootfs.gz /tftpboot/linux
