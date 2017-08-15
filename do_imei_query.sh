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
	adb -s $serial shell "cat /sys/class/leds/lcd-backlight/brightness"|tr '\r' ' '|awk '{printf $0}'
}

function check_idle_from_backlight()
{
	lcd_backlight=`get_lcd_bl`
	last_backlight=$lcd_backlight
	while [ "x$lcd_backligh" = ""  -o  $lcd_backlight -ne 0 ];
	do
		sleep 1
		lcd_backlight=`get_lcd_bl`
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
	while [ "x$b2g_nb" = ""  -o  $b2g_nb -lt 7 ];
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
fi




send_key STAR
sleep 1
send_key POUND
sleep 1
send_key NUM0
sleep 1
send_key NUM6
sleep 1
send_key POUND
sleep 1

send_key POWER


log "$serial device already remove"
exit 0
