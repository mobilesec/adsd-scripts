import re
from java.util import *
from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice
device = MonkeyRunner.waitForConnection()       # connect to a device
device.shell("input keyevent KEYCODE_POWER")    # turn screen off (or on?)
res = device.shell("dumpsys power")             # fetch power state
m = re.search(r'.*mPowerState=([0-9]+).*', res) # parse the string
if m and int(m.group(1)) == 0:                  # screen is off
  device.shell("input keyevent KEYCODE_POWER")  # turn the screen on

