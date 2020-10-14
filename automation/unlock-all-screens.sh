#!/bin/bash

list=`tempfile`

adb devices | grep -v "List of devices attached" | while read id state;
	do if [ "$state" = "unauthorized" ]; then continue; fi;
	if [ -z "$id" ]; then continue; fi

	echo "$id" >> $list
done

for id in `cat $list`; do
	dispstate=$(adb -s $id shell dumpsys power | grep 'Display Power: state' | grep -oE '(ON|OFF|SUSPEND)')
	if [ "$dispstate" == "OFF" -o "$dispstate" == "SUSPEND" ] ; then
	    echo "Screen on $id is off. Turning on."
	    adb -s "$id" shell input keyevent 26 # wakeup
	    adb -s "$id" shell input keyevent 82 # bring up PIN pad on Samsung
	    #adb -s "$id" shell input touchscreen swipe 930 380 1080 380 # unlock swipe - required e.g. for Samsung before the PIN entry -> doesn't work on new high-res screens
	    adb -s "$id" shell input text "123456"
	    adb -s "$id" shell input keyevent 66
	    echo "OK, should be on now."
	else
	    echo "Screen on $id is already on."
	    #echo "Turning off."
	    #adb -s "$id" shell input keyevent 26 # sleep
	fi
done

rm $list

exit 0
