#!/system/bin/sh
###
# this script should be "push.sh"ed to the phone to be excuted.
#
# random start $apps for $loopn times
# get
#   1. start time
#   2. cpu time, 1 sample per second
#   3. sharing number, 1 sample per second
# same to these files :
time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"
total_time_file="total_time.txt"


loopn=100

apps=(
"com.qiyi.video"
"com.xunmeng.pinduoduo"
# "com.smile.gifmaker"
"com.tencent.mobileqq"
# "com.sina.weibo"
"com.touchtype.swiftkey"
"com.tencent.karaoke"
)

# in order of $apps
# their start/main activity
# use script get_main_activ.sh to get it, **manually**
activs=(
"com.qiyi.video/.WelcomeActivity"
"com.xunmeng.pinduoduo/.ui.activity.MainFrameActivity"
# "com.smile.gifmaker/com.yxcorp.gifshow.HomeActivity"
"com.tencent.mobileqq/.activity.SplashActivity"
# "com.sina.weibo/.SplashActivity"
"com.touchtype.swiftkey/com.touchtype.LauncherActivity"
"com.tencent.karaoke/.module.splash.ui.SplashBaseActivity"
)

app_nr=${#activs[@]}

## start app $1
# write data to file
# script, kill am if it takes more than 2 seconds
function start_app() {
    echo "start ${apps[$1]}"
    # if time out , result is empty
    # sometimes am start may take forever to finish, use timeout to prevent stopping this
    # timeout seems not working..
    # loop in case of empty result
    time=""
    while [[ -z $time ]]; do
        time=$(timeout 10.0 am start -W ${activs[$1]} | grep TotalTime  \
            | sed 's/[ ][ ]*//g' | cut -d":" -f2)
    done
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

ksmd_pid=$(ps -e | grep ksmd | sed 's/[\t ][\t ]*/ /g' | cut -d ' ' -f 2)

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

sysfs_sharing_file=$(find /sys/kernel/mm/ -name "*sharing")

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
sleep 2

# start cpu moniter
cpu_moniter&
cpu_moniter_pid=$!

# start sharing moniter
sharing_moniter&
sharing_moniter_pid=$!

# pseudorandom
RANDOM=0

start_time=$SECONDS

# last start app. always start a new app
last_app=$(( $app_nr + 1 ))
i=0
while [[ $i -lt $loopn ]];
do
    ### round robin
    this_app=$((i % $app_nr))
    start_app $this_app
    i=$((i + 1))


    ### random
    # this_app=$(( RANDOM % $app_nr ))
    # while [[ $this_app -eq $last_app ]];
    # do
    #     this_app=$(( RANDOM % $app_nr ))
    # done
    # start_app $this_app
    # last_app=$this_app
    # i=$((i + 1))
done

elapsed_time=$(($SECONDS - $start_time))
echo "total time = " $elapsed_time
echo $elapsed_time > $total_time_file

# stop moniters
kill $cpu_moniter_pid
kill $sharing_moniter_pid


