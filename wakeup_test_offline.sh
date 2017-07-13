#!/system/bin/sh

echo "" > /data/sleep_test.txt
function power_key()
{
	sendevent /dev/input/event1 1 116 1
	sendevent /dev/input/event1 0 0 0
	sendevent /dev/input/event1 1 116 0
	sendevent /dev/input/event1 0 0 0
}
function wakelock()
{
	echo sleep_test >/sys/power/wake_lock
}
function wakeunlock()
{
	echo sleep_test >/sys/power/wake_unlock
}
function log()
{
	d=`date`
	capacity=`cat /sys/class/power_supply/battery/capacity`
	voltage_now=`cat /sys/class/power_supply/battery/voltage_now`
	echo "${d} ${capacity}% ${voltage_now} ${1}" 
	echo "${d} ${capacity}% ${voltage_now} ${1}" >> /data/sleep_test.txt
	sync
}

count=0
sleep_times=0
prj=`getprop ro.product.model`
ver=`getprop ro.build.version.incremental`
serial=`getprop ro.boot.serialno`
emcp=`cat /sys/block/mmcblk0/device/name`

wakelock

http_post 192.168.10.21 8001 /cq/report.php "prj=$prj&ver=$ver&serial=$serial&emcp=$emcp&cmd=wakeup&times=$sleep_times" 

while :
do
	
	level=`cat /sys/class/leds/lcd-backlight/brightness`
	
	if [ $count -ge 100 ] ; then
		# post result to server
		http_post 192.168.10.21 8001 /cq/report.php "prj=$prj&ver=$ver&serial=$serial&emcp=$emcp&cmd=wakeup&times=$sleep_times" 
		count=0
	fi
	
	if [ $level = 0 ]; then
		
		log "Set Alarm"
		wakeunlock
		busybox rtcwake -m mem -s 20
		ret=$?
		wakelock
		if [ $ret = 0 ] ; then
			log "Alarm triger"
			sleep_times=`cat /d/suspend_stats|grep "success:"|busybox awk '{print $2}'`
			log "sleep times:$sleep_times"
			let count++
			power_key
			log "send power key to wakeup lcd"
		fi
		
	fi

	sleep 1
done

