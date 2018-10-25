#!/usr/bin/env bash

time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"

adb pull /data/local/tmp/$time_file
adb pull /data/local/tmp/$cpu_file
adb pull /data/local/tmp/$sharing_file
