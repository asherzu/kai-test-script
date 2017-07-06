#!/system/bin/sh

TIMES=$1
if [ "$TIMES" = "" ] ;then
	TIMES=1
fi
stop apk_logfs
rm -fr /data/logs
function make1megastr() 
{
	str=$1
	name=$2
	rm -fr -fr $name 2>/dev/null
	echo make1megastr $name 
	for i in `busybox seq 1 65536`
	do  
    	echo "${str}" >> $name
	done 
	
}
function log()
{
	d=`date`
	capacity=`cat /sys/class/power_supply/battery/capacity`
	voltage_now=`cat /sys/class/power_supply/battery/voltage_now`
	echo "${d} ${capacity}% ${voltage_now} ${1}" 
	echo "${d} ${capacity}% ${voltage_now} ${1}" >> /data/disk.txt
	sync
}


function preapare()
{
	echo preapare
	echo disk_test >/sys/power/wake_lock
	rm -fr /data/disk.txt 2> /dev/null

	make1megastr AAAAAAAAAAAAAAA /data/A.txt
	make1megastr BBBBBBBBBBBBBBB /data/B.txt
	make1megastr TTTTTTTTTTTTTTT /data/T.txt
	make1megastr FFFFFFFFFFFFFFF /data/F.txt
	echo preapare end
}
function verify()
{
	name=$1
	size=$2
	folder=$3
	rm -fr $folder/*.img 2>/dev/null
	sync

	for i in `busybox seq 1 $size`
	do
		echo -e "\r$i\c"
		cat $name >>$folder/$i.img
	done
	echo ""
	sync
	
	df $folder >> /data/disk.txt
	
	for i in `busybox seq 1 $size`
	do
		echo -e "\r$i\c"
		busybox diff $folder/$i.img $name
		if [ $? != 0 ] ; then
			log "$name Fail"
			log "/data/$i.img"
			mv $folder/$i.img /data/e.img
			exit 1
		fi
	done
	
	
	
	log "$folder  $name PASS"

	
}
function cleanup()
{
	echo cleanup
	rm -fr /data/A.txt /data/B.txt /data/T.txt /data/F.txt 2>/dev/null
	rm -fr /data/*.img 2>/dev/null
	echo cleanup end
}
cleanup

preapare





for i in `busybox seq 1 $TIMES`
do
	log "NO $i"
	
	sizek=`busybox df /data 2>/dev/null |grep /data|busybox awk '{print $3}'`

	sizem=`busybox expr $sizek / 1024`

	sizem=`busybox expr $sizem - 50` # keep 50M
	echo $sizem
	verify /data/A.txt $sizem /data
	verify /data/B.txt $sizem /data
	verify /data/T.txt $sizem /data
	verify /data/F.txt $sizem /data
	
	
	sizek=`busybox df /data 2>/dev/null |grep /data|busybox awk '{print $3}'`

	sizem=`busybox expr $sizek / 1024`
	if [ ! -d /data/usbmsc_mnt ] ; then
		echo "don't have /data/usbmsc_mnt"
		continue
	fi
	sizek=`busybox df /data/usbmsc_mnt 2>/dev/null |grep /data|busybox awk '{print $3}'`
	echo "Write usbmsc_mnt "
	sizem=`busybox expr $sizek / 1024`
	sizem=`busybox expr $sizem - 50` # keep 50M
	verify /data/A.txt $sizem  /data/usbmsc_mnt
	verify /data/B.txt $sizem /data/usbmsc_mnt
	verify /data/T.txt $sizem /data/usbmsc_mnt
	verify /data/F.txt $sizem /data/usbmsc_mnt
	
done

cleanup