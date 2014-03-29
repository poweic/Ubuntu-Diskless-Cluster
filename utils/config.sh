#!/bin/bash

function apply_config() {
	config_folder=$1
	rootfs=$2

	INPUT=$(tail -n +2 $config_folder/config.txt)
	while read ifile location permission owner group
	do
		mkdir -p $rootfs/$location
		ofile=$rootfs/$location/$ifile
		cp -aP $config_folder/$ifile $ofile
		chmod $permission $ofile
		chown $owner:$group $ofile
	done <<< "$INPUT"
}
