#!/usr/bin/env sh

##  push all '.sh' script to device's

DEVICE_D="/data/local/tmp/"

adb push *.sh $DEVICE_D
adb push seq $DEVICE_D

