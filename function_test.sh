# test code: how to write shell sciprt
cpu_file="cpu.txt"

ksmd_pid=$(ps -e | grep ksmd | sed 's/[\t ][\t ]*/ /g' | cut -d ' ' -f 2)

# get ksmd's cpu usage using top, every second
# save to file $cpu_file
function cpu_moniter() {
    while true;
    do
        sleep 1&
        ksmd_pcpu=$(top -p $ksmd_pid -o %cpu -bn1 | tail -n1)
        echo $ksmd_pcpu >> $cpu_file
        wait $!
    done
}

> $cpu_file
cpu_moniter&
cpu_moniter_pid=$!

sleep 5
kill $cpu_moniter_pid

