#!/bin/bash
mount_point=rootfs-loop/

# mount the kernel image
mount -t ext4 -o loop rootfs $mount_point

# bind mount /usr
mount -o bind /usr $mount_point/usr

# chroot to the new environment
chroot rootfs-loop /bin/bash
