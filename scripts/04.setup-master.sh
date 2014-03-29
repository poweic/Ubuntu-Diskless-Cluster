#!/bin/bash

# Create directories required for pxe bootloader
mkdir -p /tftpboot/{linux,pxelinux.cfg}

# Set mount point for the rootfs
mount_point="rootfs-loop"

conf=master.conf/
sed "s/KERNEL_RELEASE/$(uname -r)/g" $conf/.0A0000.template > $conf/0A0000

source utils/config.sh
apply_config $conf /
/usr/local/vbird/iptables/iptables.rule

# Restart services: Network, DHCP-server, tftp boot server, tftp-server
service networking restart
service isc-dhcp-server restart
service xinetd restart
service tftpd-hpa restart

# Check TFTP and NFS server is running
function check_TFTP_server() {
  printf "Checking TFTP server is running..."
  MSG_FILE="hello.txt"
  echo "hello tftp-server" > $MSG_FILE
  mv $MSG_FILE /tftpboot
  tftp 10.0.0.1 -c get hello.txt
  ERROR=`diff $MSG_FILE /tftpboot/$MSG_FILE`
  rm $MSG_FILE
  check $ERROR
}

function check_NFS_server() {
  printf "Checking NFS server is running..."
  TMP_DIR=tmp_usr
  mkdir $TMP_DIR
  ERROR=`mount 10.0.0.1:/usr $TMP_DIR`
  umount $TMP_DIR
  rm -r $TMP_DIR
  check $ERROR
}

function check() {
  if [ "$1" == "" ]; then
    printf "\t\t \33[32m[  OK  ]\33[0m\n"
  else
    printf "\t\t \33[31m[Failed]\33[0m\n"
    exit -1
  fi  
}

check_TFTP_server
check_NFS_server

# Manual time-synchronization
service ntp stop
ntpdate time.stdtime.gov.tw
service ntp start

# Copy PXE boot loader (comes with syslinux package)
cp /usr/lib/syslinux/pxelinux.0 /tftpboot/
 
# Copy linux kernel so it can be passed onto nodes by a pxe bootloader
cp /boot/vmlinuz-$(uname -r) /tftpboot/linux
 
# Copy linux root filesystem image
cp rootfs.gz /tftpboot/linux

# Change permission
chmod -R 755 /tftpboot
