#!/bin/bash

if [ $# -lt 1 ]; then echo "Error: need command to execute"; exit 1; fi

list=`tempfile`

adb devices | grep -v "List of devices attached" | while read id state; 
	do if [ "$state" = "unauthorized" ]; then continue; fi; 
	if [ -z "$id" ]; then continue; fi

	echo "$id" >> $list
done

for id in `cat $list`; do
	echo "Executing on $id: '$@'"
	adb -s "$id" $@
done

rm $list
exit 0
