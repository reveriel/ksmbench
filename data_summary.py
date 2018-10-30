#!/usr/bin/env python3
# print three number
# total_time, avg pcpu, avg sharing pages

import csv
import numpy as np

time_file = "times.txt"
cpu_file = "cpu.txt"
sharing_file = "sharing.txt"
total_time_file = "total_time.txt"

def avg(x):
    return sum(x) / len(x)

# time_data = np.genfromtxt(time_file, delimiter=',', dtype='i8')
cpu_data = np.genfromtxt(cpu_file)
sharing_data = np.genfromtxt(sharing_file, dtype='int16')
total_time = np.genfromtxt(total_time_file, dtype='i8')

print(total_time, round(avg(cpu_data), 2), int(avg(sharing_data)))


