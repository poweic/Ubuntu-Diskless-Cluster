#!/bin/bash -e
mount_point=rootfs-loop/

if [ "$(ls $mount_point/)" == "" ]; then 
	mount -t ext4 -o loop rootfs $mount_point
fi

SLAVE_KERNEL=$(ls $mount_point/lib/modules/)
MASTER_KERNEL=$(uname -r)

echo "  Node  | Current Kernel Release "
echo "--------+------------------"
echo " master |     $MASTER_KERNEL "
echo " slave  |     $SLAVE_KERNEL  "
echo ""

# Ask user if he/she want to update slave kernel
if [ "$MASTER_KERNEL" != "$SLAVE_KERNEL" ]; then
	printf "Do you upgrade slave kernel? (\33[34m $SLAVE_KERNEL \33[0m=>\33[34m $MASTER_KERNEL \33[0m)  "
	read -p "[Y/n] " fix	
	if [ "$fix" == "Y" ] || [ "$fix" == "y" ]; then 
		printf "Upgrading slave kernel to $MASTER_KERNEL ...\t"
		rm -r $mount_point/lib/modules/$SLAVE_KERNEL
		cp -r /lib/modules/$MASTER_KERNEL $mount_point/lib/modules/
		./tar.sh

		SLAVE_KERNEL=$MASTER_KERNEL
	fi
fi

# Two files to upgrade/fix
vmlinuz=/tftpboot/linux/vmlinuz-$SLAVE_KERNEL
cfg=/tftpboot/pxelinux.cfg/0A0000

if [ "$(grep $SLAVE_KERNEL $cfg)" == "" ]; then
	config="bad"
else
	config="good"
fi

# Check broken files and ask whether fix them
if [ "$fix" == "" ]; then
	if [ "$config" == "bad" ]; then
		printf "\33[33m[Error]\33[0m PXE config 0A0000 mismatched.\n"
	fi

	if [ ! -f $vmlinuz ]; then
		printf "\33[33m[Error]\33[0m \"$vmlinuz\" not found.\n"
	fi

	if [ "$config" == "good" ] && [ -f $vmlinuz ]; then
		echo "Nothing to be done."
		exit 0
	fi

	read -p "Do you want to fix problems? [Y/n] " fix
fi

# Fix broken files
if [ "$fix" == "Y" ] || [ "$fix" == "y" ]; then 
	if [ "$config" == "bad" ]; then
		cp $cfg $(dirname $cfg)/.$(basename $cfg).backup
		sed -i "s%vmlinuz-.*$%vmlinuz-$SLAVE_KERNEL%g" $cfg
	fi

	if [ ! -f $vmlinuz ]; then
		cp /boot/vmlinuz-$SLAVE_KERNEL /tftpboot/linux/
		chmod 755 $vmlinuz
	fi
fi

if [ "$(ls $mount_point/)" != "" ]; then 
	umount $mount_point
fi

printf "\33[32m[Done]\33[0m\n"
