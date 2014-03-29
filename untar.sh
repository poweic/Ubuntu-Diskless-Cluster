#!/bin/bash -e
if [ -f rootfs ]; then
	printf "\33[33m[Warning]\33[0m Aborted. File \"rootfs\" already exists.\n"
	exit -1
fi
gzip -dc rootfs.gz | dd of=rootfs
