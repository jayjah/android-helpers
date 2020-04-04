#!/bin/bash

##### fork of: https://gist.github.com/teocci/62d7f4ecc4204a641d52b7e27d7591b3 ####
# needs following changes for my usage:
# 1. wait till usb connection to device is disconnected
# 2. after disconnected the connection statement must be recalled, cause during usb disconnecting both connections are destroyed
#     ->adb -s $SERIAL connect $address:$port (with given parameters)

#
# Created by teocci.
#
# @author teocci@yandex.com on 2017-Nov-14
#
# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
#
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do 
  address=$(adb -s $SERIAL shell ip addr show wlan0  | grep 'inet ' | cut -d' ' -f6|cut -d/ -f1)
  foo=$(adb -s $SERIAL shell ip addr show wlan0  | grep 'inet ' | cut -d' ' -f6|cut -d/ -f1  | cut -d . -f 4)
  port="7$(printf "%03d" $foo)"
  id="${SERIAL%%:*}"

  if ! valid_ip $id; then
  	printf "Connecting to %s\n" "$SERIAL"
    adb -s $SERIAL tcpip $port
    adb -s $SERIAL connect $address:$port
  fi
done

adb devices
