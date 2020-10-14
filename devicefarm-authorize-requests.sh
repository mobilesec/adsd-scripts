adb devices | while read id state; do if [ "$state" = "unauthorized" ]; then adb -s $id reconnect; fi; done
