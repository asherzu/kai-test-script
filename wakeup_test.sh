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

while :
do
	
	
	level=`cat /sys/class/leds/lcd-backlight/brightness`
	wakelock
	
	if [ $level = 0 ]; then
		wakeunlock
		log "Set Alarm"
		busybox rtcwake -m mem -s 20
		if [ $? = 0 ] ; then
			log "Alarm triger"
			sleep_info=`cat /d/suspend_stats|grep "success:"`
			log "$sleep_info"
		
			power_key
			log "send power key to wakeup lcd"
		fi
		
	fi
	sleep 1
done

