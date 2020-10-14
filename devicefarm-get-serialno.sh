adb devices | grep -v "List of devices attached" | while read id state; do if [ "$state" != "unauthorized" ]; then if [ -z "$id" ]; then continue; fi; adb -s "$id" get-serialno; fi; done
