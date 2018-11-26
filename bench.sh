#!/system/bin/sh
###
# this script should be "push.sh"ed to the phone to be excuted.
#
#
# get
#   1. start time
#   2. cpu time, 1 sample per second
#   3. sharing number, 1 sample per second
# same to these files :
time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"
total_time_file="total_time.txt"

## global variables
loopn=100

source ./config.sh

# number of apps
app_nr=${#activs[@]}
# check
if [[ ${#activs[@]} -ne ${#apps[@]} ]]; then
    echo "ERROR: number of activs and apps no match. Exit."
    exit 1
fi

# the pid of ksmd
ksmd_pid=$(ps -e | grep ksmd | sed 's/[\t ][\t ]*/ /g' | cut -d ' ' -f 2)

# the sysfs file name, pksm_pages_sharing or ksm_pages_sharing
sysfs_sharing_file=$(find /sys/kernel/mm/ -name "pages_sharing")

## start app $1
# write data to file
function start_app() {
    echo "start ${apps[$1]}"
    # if time out , result is empty
    # sometimes am start may take forever to finish, use timeout to prevent stopping this
    # timeout seems not working..
    # loop in case of empty result
    # while [[ -z $time ]]; do
    time=$(am start -W ${activs[$1]} -c android.intent.category.LAUNCHER \
        -a android.intent.action.MAIN | grep TotalTime  \
        | sed 's/[ ][ ]*//g' | cut -d":" -f2)
    # timeout 5.0 am start -W ${activs[$1]}
    echo "time = $time"
    echo "$1,$time" >> $time_file
}

# kill all apps
function kill_all_apps() {
	for app in "${apps[@]}"
	do
        am force-stop $app
    done
}

# get ksmd's cpu usage using top, every second
# save to file $cpu_file
function cpu_moniter() {
    # if ksm deamon no found, this happens when ksm is off
    if [[ -z $ksmd_pid ]]; then
        # also do this, control variable
        while true;
        do
            sleep 1&
            pcpu=$(top -p 1 -o %cpu -bn1 | tail -n1)
            echo 0 >> $cpu_file
            wait $!
        done
    fi

    while true;
    do
        sleep 1&
        ksmd_pcpu=$(top -p $ksmd_pid -o %cpu -bn1 | tail -n1)
        echo $ksmd_pcpu >> $cpu_file
        wait $!
    done
}


# get ksmd's pages_sharing, every second
# save to file $sharing_file
function sharing_moniter() {
    # if this file does not exists, this happens when ksm is off
    if [[ -z $sysfs_sharing_file ]]; then
        # control variable
        while true;
        do
            sleep 1&
            # sharing=$(cat $sysfs_sharing_file)
            echo 0 >> $sharing_file
            wait $!
        done
    fi

    while true;
    do
        sleep 1&
        sharing=$(cat $sysfs_sharing_file)
        echo $sharing >> $sharing_file
        wait $!
    done
}

# signal handler, kill all subprocess
function intexit() {
    kill -HUP -$$
}

function hupexit() {
    # HUP'd (probably by intexit)
    echo
    echo "Interrupted"
    exit
}



################
# main

trap hupexit HUP
trap intexit INT

#clean file
> $time_file
> $cpu_file
> $sharing_file

kill_all_apps
sleep 3

# start cpu moniter
cpu_moniter&
cpu_moniter_pid=$!

# start sharing moniter
sharing_moniter&
sharing_moniter_pid=$!

start_time=$SECONDS

# last start app. always start a new app
last_app=$(( $app_nr + 1 ))

# read the seq file. launch
seq=$(cat seq)
for app_i in ${seq[@]}; do

    start_app $app_i

    sleep 2
    # go home
    am start -a android.intent.action.MAIN -c android.intent.category.HOME
    sleep 1
done


elapsed_time=$(($SECONDS - $start_time))
echo "total time = " $elapsed_time
echo $elapsed_time > $total_time_file

# stop moniters
kill $cpu_moniter_pid
kill $sharing_moniter_pid


