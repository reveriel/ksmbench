#!/usr/bin/env bash

# time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"
total_time_file="total_time.txt"
num_resume_file="num_resume.txt"

# adb pull /data/local/tmp/$time_file
adb pull /data/local/tmp/$cpu_file
adb pull /data/local/tmp/$sharing_file
adb pull /data/local/tmp/$total_time_file
adb pull /data/local/tmp/$num_resume_file


