#/bin/bash
serial=$1
num=0
total=4000
if [ "x$2" != "x" ] ; then
	total=$2
fi
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

