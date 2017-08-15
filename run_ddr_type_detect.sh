#!/bin/bash

serial=$1
num=0
function log()
{
	d=`date`
	echo "${d} : $*" |tee -a $serial.txt
	sync
}

function adb_cmd()
{
	adb -s $serial $*
}
function detect()
{
	adb_cmd wait-for-device
	adb_cmd reboot bootloader
	sleep 2
	fastboot -s $serial oem memory_map
	sleep 2
	fastboot -s $serial oem dump 87CC0000:20000 
	grep -a "PULL UP" dump.img >>$serial.txt
	rm dump.img
	fastboot -s $serial reboot-bootloader
	sleep 2
	fastboot -s $serial oem dump 87CC0000:20000 
	grep -a "PULL UP" dump.img >>$serial.txt
	rm dump.img
	fastboot -s $serial reboot
	sleep 2
}



mkdir $serial
cd $serial
adb_cmd wait-for-device
emcp_name=`adb -s $serial shell "cat /sys/block/mmcblk0/device/name"`
log "EMMC Name is:$emcp_name"
while [ $num -le 1000 ] ;
do
	log ========$num =======

	detect
	let num++
done
cd ..

