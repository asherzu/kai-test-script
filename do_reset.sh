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

log $serial Wait device Power on
#adb -s $serial wait-for-device
#adb -s $serial root
adb -s $serial wait-for-device

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


sleep 3
log $serial Long press Power key
send_key POWER 8

sleep 3
log $serial Move Item to reset
send_key DPAD_DOWN
sleep 3
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
		break; 
	fi
	sleep 1
done
log "$serial device already remove"
