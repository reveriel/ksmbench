#!/usr/bin/env bash
# this script runs on host machine
#   (macOS, brew install coreutils to get command gtimeout)
# loop 10 times

nloop=10

NOKSM=0
PKSM=0
PKSM_D=0
case $1 in
    -n)
        NOKSM=1
        note="noksm, seq, loop 100, wait2s-home-wait1"
        summary_file="summary-noksm.txt"
        ;;
    -p)
        PKSM=1
        if [ $# -ne 3 ]; then
            echo "need 2 arguments,<pages_to_scan> <sleep_ms>"
            echo "exit"
            exit 1
        fi
        pages_to_scan=$2
        sleep_ms=$3
        note="pksm, pages_to_scan $pages_to_scan, sleep_ms $sleep_ms, seq, loop 100,
        wait2s-home-wait1"
        summary_file="summary-$pages_to_scan-$sleep_ms.txt"
        ;;
    *)
        PKSM_D=1
        if [ $# -ne 4 ]; then
            echo "need 4 arguments,<delay_time> <sleep_ms> <ksm_n> <pg_max>"
            echo "exit"
            exit 1
        fi
        delay_time=$1
        # pages_to_scan=$1
        sleep_ms=$2
        ksm_n=$3
        pg_max=$4
        note="pksm-delay-time, delay_time $delay_time, sleep $sleep_ms, ksm_n $ksm_n,
        pg_max $pg_max, seq, loop 100, wait2s-home-wait1"
        summary_file="summary-$delay_time-$sleep_ms-$ksm_n-$pg_max.txt"
        ;;
esac

# if no devices, adb devices | wc -l = 2
# if devices is up, adb devices | wc -l = 3
function wait_until_up() {
    ret=2
    while [ $ret -eq 2 ]; do
        sleep 5
        ret=$(adb devices | wc -l)
    done
}

function init_parameters() {
    if [[ $PKSM_D -eq 1 ]]; then
        adb shell "echo $delay_time > /sys/kernel/mm/pksm/delay_time"
        adb shell "echo $sleep_ms > /sys/kernel/mm/pksm/sleep_millisecs"
        adb shell "echo $ksm_n > /sys/kernel/mm/pksm/n"
        adb shell "echo $pg_max > /sys/kernel/mm/pksm/pages_to_scan_max"
    fi
    if [[ $PKSM -eq 1 ]]; then
        adb shell "echo $pages_to_scan > /sys/kernel/mm/pksm/pages_to_scan"
        adb shell "echo $sleep_ms > /sys/kernel/mm/pksm/sleep_millisecs"
    fi
}

function reboot_phone() {
    echo "Reboot phone now."
    adb reboot
    echo "Waiting phone up ..."
    wait_until_up
    echo "Phone up."
    echo "Wait 60 seconds here..."
    sleep 60
}

echo $note
echo "Log file $summary_file"
echo $note > $summary_file

echo "push bench.sh and seq to device"
adb push bench.sh /data/local/tmp/
adb push seq /data/local/tmp/

echo "Start benching ..."
i=1
while [ $i -le $nloop ]; do
    echo "loopbench.sh : round  ($i / $nloop)"

    reboot_phone
    init_parameters

    retry_left=5 # max number of retry times
    until [ $retry_left -eq 0 ]
    do
        echo $(( 6 - $retry_left )) "try"

        # gtimeout 1.0 ls / > /dev/null && break
        # timeout 900 seconds
        gtimeout 900.0 adb shell "cd /data/local/tmp/ && ./bench.sh" && break

        # retry
        # reboot

        reboot_phone
        init_parameters

        retry_left=$(( $retry_left - 1 ))
    done  # retry loop

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



