#!/usr/bin/env bash
# this script runs on host machine
#   (macOS, brew install coreutils to get command gtimeout)
# loop 10 times

nloop=10

if [ $# -ne 2 ]; then
    echo "need two argument, <pages_to_scan> <sleep_ms>"
    echo "exit"
    exit 1
fi

pages_to_scan=$1
sleep_ms=$2

note="noksm, pages_to_scan $pages_to_scan, sleep $sleep_ms, RR, loop 100, wait2s-home-wait1"

# if no devices, adb devices | wc -l = 2
# if devices is up, adb devices | wc -l = 3
wait_until_up() {
    ret=2
    while [ $ret -eq 2 ]; do
        sleep 5
        ret=$(adb devices | wc -l)
    done
}

echo $note

echo "Reboot phone now."
adb reboot
echo "Waiting phone up ..."
wait_until_up
echo "Phone up."
echo "Wait 60 seconds here..."
sleep 60

adb shell "echo $pages_to_scan > /sys/kernel/mm/pksm/pages_to_scan"
adb shell "echo $sleep_ms > /sys/kernel/mm/pksm/sleep_millisecs"

summary_file="summary-$pages_to_scan-$sleep_ms.txt"
echo "Log file $summary_file"
echo $note > $summary_file

echo "push bench.sh to device"
adb push bench.sh /data/local/tmp/

echo "Start benching ..."
i=1
while [ $i -le $nloop ]; do
    echo "bench.sh" "round : " $i

    retry_left=5 # max number of retry times
    until [ $retry_left -eq 0 ]
    do
        echo $(( 6 - $retry_left )) "try"

        # gtimeout 1.0 ls / > /dev/null && break
        # timeout 300 seconds
        gtimeout 600.0 adb shell "cd /data/local/tmp/ && ./bench.sh" && break

        retry_left=$(( $retry_left - 1 ))
    done

    if [ $retry_left -eq 0 ]; then
        echo "bench.sh always fail, exit"
        break;
    fi

    # archive
    ./save_data.sh "$note"
    ./data_summary.py >> $summary_file

    i=$((i + 1))
done
echo "End benching"



