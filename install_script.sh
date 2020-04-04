#!/bin/bash


install_to_device(){
local prettyName=$(adb -s $1 shell getprop ro.product.model)
	echo "Starting Installatroning on $prettyName"
	for APKLIST in $(find . -name "mainActivity-release.apk" -not -name "*unaligned*");
	  do
	  echo "Installatroning $APKLIST on $prettyName"
	  adb -s $1 install -r $APKLIST
	  adb -s $1 shell am start -n NUNDLEID/.PATH TO MAIN ACTIVITY
	  adb -s $1 shell input keyevent KEYCODE_WAKEUP
	  done
	  echo "Finished Installatroning on $prettyName"
}

echo "Install application on all connected devices ..."
# driver/gradlew assembleProdDebug

for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do 
  install_to_device $SERIAL&
done
