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
	echo "${d} : $*"  |tee -a $serial.txt
	sync
}
emcp_name=`adb -s $serial shell "cat /sys/block/mmcblk0/device/name"`
log "EMCP:$emcp_name"

log =============== $num =================== |tee -a $serial.txt
./do_reset.sh $serial fromBacklight|tee -a $serial.txt
let num++

while [ $num -le $total ] 
do
log =============== $num =================== |tee -a $serial.txt
./do_reset.sh $serial fromBacklight|tee -a $serial.txt
if [ $? -ne 0 ] ; then
	exit 1
fi
let num++
done

