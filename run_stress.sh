#!/bin/bash
echo on
seial=$1
adb -s $seial wait-for-device
adb -s $seial root
adb -s $seial wait-for-device
adb -s $seial remount

adb -s $seial push stressapptest_arm32bit /system/bin/stressapptest
adb -s $seial push dropcache.sh /system/bin/

adb -s $seial shell sync
adb -s $seial shell sh /system/bin/dropcache.sh

echo $seial > ${seial}.log
feeK=`adb -s $seial shell cat /proc/meminfo|grep MemFree|awk '{print $2}'`
echo $feek
feeM=`expr $feeK / 1024 - 10`
testM=`expr $feeM \* 3 / 4 `

echo $feeM
echo $testM
echo "adb -s $seial shell stressapptest -s 86400 -m 2 -i 2 -c 4 -C 4 -M $testM" >> ${seial}.log
adb -s $seial shell cat /sys/block/mmcblk0/device/name >> ${seial}.log
adb -s $seial shell cat /proc/meminfo >> ${seial}.log
#adb -s $seial shell stressapptest -s 86400 -m 2 -i 2 -c 4 -C 4 -M $testM >>  ${seial}.log
# 48 H
adb -s $seial shell stressapptest -s 172800  -m 2 -i 2 -c 4 -C 4 -M $testM >>  ${seial}.log
