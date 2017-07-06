#!/bin/sh

serial=$1
key=$2
key_value=0
event=/dev/input/event0
case $key in
	POWER)
		key_value=116
		event=/dev/input/event1
		;;
	DPAD_UP)
		key_value=103
		;;
	DPAD_DOWN)
		key_value=108
		;;
	DPAD_LEFT)
		key_value=105
		;;
	DPAD_RIGHT)
		key_value=106
		;;
	SOFT_LEFT)
		key_value=139
		;;
	SOFT_RIGHT)
		key_value=158
		;;
	ENTER)
		key_value=352
		;;
	CALL)
		key_value=231
		;;
	DEL)
		key_value=116
		;;
	STAR)
		key_value=522
		;;
	POUND)
		key_value=523
		;;
	NUM1)
		key_value=2
		;;
	NUM2)
		key_value=3
		;;
	NUM3)
		key_value=4
		;;
	NUM4)
		key_value=5
		;;
	NUM5)
		key_value=6
		;;
	NUM6)
		key_value=7
		;;
	NUM7)
		key_value=8
		;;
	NUM8)
		key_value=9
		;;
	NUM9)
		key_value=10
		;;
	NUM0)
		key_value=11
		;;
	*)
		echo "Unsupport key"
		exit -1
		;;
esac

# key down
adb -s $serial shell "sendevent $event 1 $key_value 1"
adb -s $serial shell "sendevent $event 0 0 0"

if [ "x$3" != "x" ] ; then
	sleep $3

fi

# key up
adb -s $serial shell "sendevent $event 1 $key_value 0"

adb -s $serial shell "sendevent $event 0 0 0"
sleep 0.6


		
