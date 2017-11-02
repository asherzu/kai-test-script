#!/bin/bash

cmd=$1
if [ "$cmd" = "" ]  ;then
	exit 0
fi
SAVEIFS=$IFS
IFS=$'\n'

PREFIX="List"
for device in `adb devices`
do
	#echo $device
	if [[ $device == $PREFIX* ]] ; then
		continue
	fi
	serial=`echo $device|awk '{print $1}'`
	
	$cmd $serial $2 $3 $4 &
done
wait

IFS=$SAVEIFS


