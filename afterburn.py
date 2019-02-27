#!/usr/bin/python3

############################################################################
#                                                                          #
#   Handles my fan speed on my GTX1080. Works surprisingly well.           #
#   Recommended to add on startup. Can work on Windows with tweaks.        #
#                                                                          #
############################################################################


from time import sleep
from subprocess import run,PIPE
import re
from math import floor
import psutil
from os import getpid

# Kill self if already running. Assumes script is named afterburn.py
pid = getpid()
for p in psutil.process_iter():
    if 'afterburn.py' in ' '.join(p.cmdline()) and not p.pid == pid:
        exit()

# Setup Regular expressions
qt = re.compile("Current Temp.*: ([0-9]+) C")

# Wait time, in seconds, between GPU polls. Fan is updated at this frequency as well.
waittime=5

def call_pipe(arg):
    return run(arg,stdout=PIPE,stderr=PIPE,universal_newlines=True,shell=True)

def set_auto(tf):
    call_pipe("nvidia-settings -a [gpu:0]/GPUFanControlState="+str(tf))

def set_fan(speed):
    call_pipe("nvidia-settings -a [gpu:0]/GPUFanControlState=1")
    return call_pipe("nvidia-settings -a [fan:0]/GPUTargetFanSpeed="+str(speed))

def query_gpu():
    x = call_pipe("nvidia-smi -q")
    x = x.stdout
    ret = int(qt.findall(x)[0])
    return ret

speed = 15
while True:
    gpud = query_gpu()
    curTemp = gpud
    # Start raising speed at 30C,and max out at 75C
    st = floor((curTemp-30)*2.125)
    # Cap speed at 100% just in case things go haywire
    if st > 100:
        st = 100
    if not st == speed:
        set_fan(st)
        print("Setting fan speed to {} %".format(st))
        speed = st
    sleep(waittime)
