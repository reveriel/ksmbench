#/bin/bash

# this script generate a sequence of random numbers.
# number ranges from 0 to #apps-1 in 'config.sh'
# each number represent a luncher event
# We will generate a sequence and save it to a file
# 'seq'
# we run benchmark according to this 'seq'


## global variables
# sequence length
len=100
# distribution
# the 0th app will be launched for 9 times
# see README.md
dist=(
  9
  9
  7
 10
  8
  8
  7
  5
  4
  2
  5
  2
  2
  8
  5
  5
  4
)
# random number seed
r=100
# the result sequence
seq=()




function rand() {
    r=$((r * 214013 + 2531011))
    if [[ $r -le 0 ]]; then
        r=$(( - r ))
    fi
}


function init_seq() {
    local i=0;
    local app_i=0;

    while [[ app_i -lt ${#dist[@]} ]]; do
        # echo ${dist[$app_i]}
        while [[ ${dist[$app_i]} -ne 0 ]]; do
            dist[$app_i]=$((${dist[$app_i]} - 1))
            seq[$i]=$app_i
            i=$(($i + 1))
        done
        app_i=$(($app_i + 1))
    done
}

function shuffle() {
    local i=$((${#seq[@]} - 1))
    while [[ $i -gt 0 ]]; do
        rand
        local j=$(($r % $i))
        local tmp=${seq[$i]}
        seq[$i]=${seq[$j]}
        seq[$j]=$tmp

        i=$(($i - 1))
    done
}
function print_seq() {
    for i in ${seq[@]}; do
        echo $i
    done
}


####### main

init_seq
shuffle
print_seq


