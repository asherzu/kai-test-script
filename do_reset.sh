#!/bin/bash
function log()
{
	d=`date`
	echo "${d} : $*" 
	sync
}

serial=$1
function send_key()
{
	./sendkey.sh $serial $1 $2
}

function get_lcd_bl()
{
	adb -s $serial wait-for-device

	adb -s $serial shell "cat /sys/class/leds/lcd-backlight/brightness"|tr '\r' ' '|awk '{printf $0}'
}

function check_idle_from_backlight()
{
	lcd_backlight=`get_lcd_bl`
	last_backlight=255
	
	
	
	while :
	do
		lcd_backlight=`get_lcd_bl`
		if [ "$lcd_backlight" -ge 0 ] 2>/dev/null ;then 
			echo "$lcd_backlight is number." >/dev/null
		else 
			echo "get backlight value fail"
			continue
		fi 
		if [ $lcd_backlight -eq 0 ] ; then
			#echo "lcd aready off"
			break
		fi
		sleep 1
		
		if [ $lcd_backlight -ne $last_backlight ];then
			log $serial lcd backlight is $lcd_backlight
		fi
		last_backlight=$lcd_backlight
	done
	log $serial LCD already off

	sleep 3

	log $serial Light on LCD
	# unlock lcd
	send_key POWER
	log $serial Unlock screen
	send_key STAR 3
	
}
function get_b2g_process_num()
{
	adb -s $serial shell "ps|grep /system/b2g/b2g"|wc -l
}


function check_idle_from_process()
{
	b2g_nb=`get_b2g_process_num`
	last_b2g_nb=$b2g_nb
	while [ "x$b2g_nb" = ""  -o  $b2g_nb -lt 6 ];
	do
		sleep 1
		b2g_nb=`get_b2g_process_num`
		if [ $last_b2g_nb -ne $b2g_nb ];then
			log $serial b2g process number is $b2g_nb
		fi
		last_b2g_nb=$b2g_nb
	done
	log $serial already enter idle
}
log $serial Wait device Power on
#adb -s $serial wait-for-device
#adb -s $serial root
adb -s $serial wait-for-device


if [ "x$2" != "x" ] ; then
	check_idle_from_backlight
else
	check_idle_from_process
fi

sleep 1
log $serial Long press Power key
send_key POWER 8

sleep 1
log $serial Move Item to reset
send_key DPAD_DOWN
sleep 1
log $serial Select to reset
send_key ENTER


device=`adb devices|grep $serial`
count=0
while [ "x$device" != "x" ];
do
	log "$serial  $count s Wait device remove"
	device=`adb devices|grep $serial`
	let count++
	if [ $count -ge 30 ]; then
		log "$serial reset timeout"
		exit 1
		break; 
	fi
	sleep 1
done
log "$serial device already remove"
exit 0
