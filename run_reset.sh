#/bin/bash
serial=$1
with_nfc_test=$2
num=0
total=1000
log_file=${serial}_reboot_test.txt

if [ "x$2" != "x" ] ; then
	total=$2
fi
function log()
{
	d=`date`
	echo "${d} : $*"  |tee -a ${log_file}
	sync
}
emcp_name=`adb -s $serial shell "cat /sys/block/mmcblk0/device/name"`
log "EMCP:$emcp_name"

log =============== $num ===================
./do_reset.sh $serial fromBacklight $with_nfc_test|tee -a ${log_file}
let num++

while [ $num -le $total ] 
do
log =============== $num =================== 
./do_reset.sh $serial fromBacklight $with_nfc_test|tee -a ${log_file}
if [ $? -ne 0 ] ; then
	exit 1
fi
let num++
done

