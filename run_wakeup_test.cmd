
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
echo = "���ֶ�ִ��adb shell ������ /system/bin/wakeup_test.sh & ��ʼ����"
echo = "ע�⣺������ ����&��"
echo =       ������ɺ�ֱ�Ӱγ�usb��
echo =       ���Բ�������������PC������---�����Ŀ���ԣ���ͨƽ̨�����������Խ���˯�ߡ�
echo =======================================================
echo =
echo = 
echo =�ڲ�����ɺ�ִ��adb pull /data/sleep_test.txt ��ȡlog

