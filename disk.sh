#!/system/bin/sh

TIMES=$1
if [ "$TIMES" = "" ] ;then
	TIMES=1
fi

function make1megastr() 
{
	str=$1
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 
	do  
    	str="${str}${str}"  
	done  
	echo ${str:0:1048575}
	
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


function init()
{
	rm /data/disk.txt 2> /dev/null
	
	str=`make1megastr A`
	echo -e "${str}" > /data/A.txt
	str=`make1megastr B`
	echo -e "${str}" > /data/B.txt
	str=`make1megastr T`
	echo -e "${str}" > /data/T.txt
	str=`make1megastr F`
	echo -e "${str}" > /data/F.txt

}
function verify()
{
	name=$1
	size=$2
	rm /data/1.img /data/2.img 2>/dev/null
	for i in `busybox seq 1 $size`
	do
		cat $name >>/data/1.img
	done
	sync
	for i in `busybox seq 1 $size`
	do
		cat $name >>/data/2.img
	done
	sync
	ls -l /data/2.img /data/1.img
	busybox diff /data/2.img /data/1.img
	if [ $? = 0 ] ; then
		log "$name PASS"
	else 
		log "$name Fail"
		busybox diff -a /data/2.img /data/1.img >> /data/disk.txt
		exit 1
	fi
	
}
function cleanup()
{
	rm /data/A.txt /data/B.txt /data/T.txt /data/F.txt 2>/dev/null
	rm /data/1.img 2>/dev/null
	rm /data/2.img 2>/dev/null
}
cleanup
init

sizek=`busybox df 2>/dev/null |grep /data|busybox awk '{print $3}'`

sizem=`busybox expr $sizek / 1024`

sizem=`busybox expr $sizem - 10` # keep 10M

sizeHalf=`busybox expr $sizem / 2`

for i in `busybox seq 1 $TIMES`
do
	log "NO $i"
	verify /data/A.txt $sizeHalf
	verify /data/B.txt $sizeHalf
	verify /data/T.txt $sizeHalf
	verify /data/T.txt $sizeHalf
done

#cleanup