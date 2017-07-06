# kai-test-script
I would like to write some script for auto stress testing. it has below limits.
1. I hope the scripts could be call by Jenkins
2. it is depend on our project. so maybe this script is unused for your project.
3. it is request adb, so device must is eng or userdebug version

# do_reset.sh
reset device through send keys

cmd as:./dispatch.sh ./run_reset.sh

# run_disk.sh
do EMMC write and read test on /data and 
cmd as:./dispatch.sh ./run_disk.sh

# run_stress.sh
Do RAM stress test, it is through google stress test aplp

