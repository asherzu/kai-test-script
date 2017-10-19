#/bin/bash
seial=$1

log_file=${seial}_disk_stress.txt

adb -s $seial wait-for-device
adb -s $seial root
adb -s $seial wait-for-device
adb -s $seial remount
adb -s $seial push stressapptest_arm32bit /system/bin/stressapptest
adb -s $seial push diskplus.sh /system/bin/
adb -s $seial push busybox /system/bin/
adb -s $seial shell sync

adb -s $seial shell diskplus.sh  600 |tee -a  $log_file

