#!/bin/bash

list=`tempfile`

adb devices | grep -v "List of devices attached" | while read id state; 
	do if [ "$state" = "unauthorized" ]; then continue; fi; 
	if [ -z "$id" ]; then continue; fi

	echo "$id" >> $list
done

for id in `cat $list`; do
	#echo "$id: " `adb -s "$id" shell getprop ro.build.id` `adb -s "$id" shell getprop ro.vendor.build.security_patch`
	serialno=`adb -s "$id" shell getprop ro.serialno`
	build_id=`adb -s "$id" shell getprop ro.build.id`
	build_fp=`adb -s "$id" shell getprop ro.build.fingerprint`
	build_date_utc=`adb -s "$id" shell getprop ro.build.date.utc`
	patchlevel=`adb -s "$id" shell getprop ro.build.version.security_patch`
	androidrelease=`adb -s "$id" shell getprop ro.build.version.release`
	kernelversion=`adb -s "$id" shell cat /proc/version`
	if [ -z "$serialno" -o -z "$build_id" -o -z "$build_fp" -o -z "$build_date_utc" -o -z "$patchlevel" -o -z "$androidrelease" -o -z "$kernelversion" ]; then
		echo "Couldn't get all fields, skipping insert for $serialno"
	else
		echo "Updating details on $serialno: '$build_id', '$build_fp', '$build_date_utc', '$patchlevel', '$androidrelease', '$kernelversion'"
		echo "insert into firmware_info (device_id, build_id, build_fingerprint, build_date_utc, security_patch_level, aosp_version_id, kernel_version, source) values( (select device_id from lab_devices where serial_number='$serialno'), '$build_id', '$build_fp', to_timestamp('$build_date_utc'), '$patchlevel', (select version_id from aosp_versions where version='$androidrelease'), '$kernelversion', 'trusted lab' );" | psql -h adsec-data -U asec -d asec 2>&1
	fi
done

rm $list
exit 0
