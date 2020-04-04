#!/bin/bash

check_device(){
local prettyName=$(adb -s $1 shell getprop ro.product.model)
	echo "Checking on $prettyName"
	adb -s $1 shell cat /proc/cpuinfo | grep aarch64
}

echo "Check if connected devices are 64 bit"
for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do 
  check_device $SERIAL&
done
