#!/bin/bash
numdev=`~/devicefarm-get-serialno.sh  | wc -l`
expected=26

if [ $numdev -lt $expected ]; then
	echo "Only $numdev devices connected through ADB at the moment, expected $expected:"
	echo
	adb devices -l
	exit 1
else
	#echo "Expected number of devices ($expected) seems connected to ADB"
	exit 0
fi
