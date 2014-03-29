#!/bin/bash -e
mount_point=rootfs-loop/

# mount the kernel image
mount -t ext4 -o loop rootfs $mount_point

source utils/config.sh
apply_config client.conf/ $mount_point

umount $mount_point

printf "\33[32m[ Done ]\33[0m\n"
