
adb wait-for-device
adb root
adb wait-for-device
adb remount
adb push wakeup_test.sh /system/bin/
adb push busybox /system/bin/
adb shell chmod 777 /system/bin/wakeup_test.sh 
adb shell chmod 777 /system/bin/busybox 

@echo off
echo =
echo ========================================================
echo =
echo = "请手动执行adb shell 后输入 /system/bin/wakeup_test.sh & 开始测试"
echo = "注意：别忘记 输入&，"
echo =       输入完成后直接拔出usb线
echo =       可以插入充电器（不是PC）测试---这个项目可以，高通平台插入充电器可以进入睡眠。
echo =======================================================
echo =
echo = 
echo =在测试完成后执行adb pull /data/sleep_test.txt 获取log

