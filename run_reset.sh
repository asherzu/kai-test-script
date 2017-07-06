#/bin/bash
serial=$1
num=1001
total=4000
function log()
{
	d=`date`
	echo "${d} : $*" 
	sync
}
emcp_name=`adb -s $serial shell "cat /sys/block/mmcblk0/device/name"`
log "EMCP:$emcp_name"
while [ $num -le $total ] 
do
log =============== $num =================== |tee -a $serial.txt
./do_reset.sh $serial |tee -a $serial.txt

num=`expr $num + 1`
done

