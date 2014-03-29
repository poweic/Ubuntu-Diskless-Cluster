#!/bin/bash

function generate_kernel_image() {

  # zooz <jablonskis@gmail.com>
  # a script to create a basic compressed rootfs for diskless nodes 
  # set variables
  # size in megabytes
  rootfs_size="512"

  # create a rootfs file
  dd if=/dev/zero of=rootfs bs=1k count=$(($rootfs_size * 1024))

  # create an ext4 file system
  mkfs.ext4 -m0 -F -L root rootfs

  # create a mount point
  mkdir -p $mount_point

  # mount the newly created file system
  mount -t ext4 -o loop rootfs $mount_point

  # cd into it and create required directory structure
  cd $mount_point && mkdir -p bin boot dev etc home \
  mnt proc root sbin sys usr/{bin,lib} var/{lib,log,run,tmp} \
  var/lib/nfs tmp var/run/netreport var/lock/subsys

  # copy required files into created directories
  cp -ap /etc .
  cp -ap /dev .
  cp -ap /bin .
  cp -ap /sbin .
  cp -ap /lib .
  # cp -ap /var .
  cp -ap /var/lib/nfs var/lib
  cp -ap /usr/bin/id usr/bin
  #cp -ap /root/.bashrc root/
  #cp -ap /root/.bash_profile root/
  #cp -ap /root/.bash_logout root/

  # special files needed by "apt-get"
  mkdir var/run/sshd
  # sudo mkdir -p var/cache/apt/archives/partial
  # sudo touch var/cache/apt/archives/lock
  # sudo chmod 640 var/cache/apt/archives/lock

  # cd out of the mount point
  cd ..
}

function setup_client_config() {
  # Setup client configuration

  # change permissions, owner, group
  conf=client.conf/

  source utils/config.sh
  apply_config $conf $mount_point

  # for SSH-server on client nodes
  mkdir $mount_point/var/run/sshd/

  # Disable update-motd when logging in
  mv $mount_point/etc/update-motd.d/ $mount_point/etc/.update-motd.d.backup/
}

function compress_kernel_image() {
  # Compress the rootfs into .gz file
  gzip -c rootfs | dd of=rootfs.gz
}

# set mount point for the rootfs
mount_point="rootfs-loop"

generate_kernel_image
setup_client_config

# umount the rootfs-loop
umount $mount_point

compress_kernel_image
