#!/usr/bin/env bash
# this script runs on host machine
#   (macOS, brew install coreutils to get command gtimeout)
# loop 10 times

nloop=10

note="pksm, pages_to_scan 100, sleep 100, RR, loop 100, wait1s"

echo $note
echo "are you sure the configuration is right? [y/n]"
read -n1 ans
case $ans in
    y)
        echo
        echo "continue test"
        ;;
    n)
        echo
        echo "exit"
        exit 0
        ;;
    *)
        echo
        echo "exit"
        exit 0
        ;;
esac

summary_file="summary.txt"

echo $note > $summary_file

i=1
while [ $i -le $nloop ]; do
    echo "bench.sh" "round : " $i

    retry_left=5 # max number of retry times
    until [ $retry_left -eq 0 ]
    do
        echo $(( 6 - $retry_left )) "try"

        # gtimeout 1.0 ls / > /dev/null && break
        # timeout 300 seconds
        gtimeout 300.0 adb shell "cd /data/local/tmp/ && ./bench.sh" && break

        retry_left=$(( $retry_left - 1 ))
    done

    if [ $retry_left -eq 0 ]; then
        echo "always fail, break"
        break;
    fi

    # archive
    ./save_data.sh "$note"
    ./data_summary.py >> $summary_file

    i=$((i + 1))
done

