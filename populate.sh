#!/bin/bash

SMOKETARGETS=/docker/smokeping/config/Targets

while getopts ":hf:" opt; do
    case $opt in
        f)
            DEVFILE="$OPTARG"
            ;;
        h)
            echo "Usage: $0 -f <devicefile.csv>"
            ;;
        \?)
            echo "Invalid option: -$OPTARG." >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# Remove Windows carriage returns
#tr -d '\r' < $1 > $1

# Place device list in the Cacti container and add devices.
cp "$DEVFILE" /docker/cacti/data/
chmod 600 "/docker/cacti/data/$DEVFILE"
#docker exec cacti /createdevices.sh -d -g -f "$DEVFILE"

# Create blank Smokeping Targets file
echo "*** Targets ***

probe = FPing

menu = Top
title = Network Latency Grapher
remark = Welcome to the MCNC Network Probe Smokeping Server. Here you will learn all about the latency of your network.

" > $SMOKETARGETS

# Add devices to Smokeping
while IFS="," read var1 var2 var3

do
DEVICENAME=$(echo $var1 | sed -r 's/(\W|_)//g')
echo "+ $DEVICENAME
menu = $var1
title = $var1 ($var2)
host = $var2
" >> $SMOKETARGETS
done < "$DEVFILE"

# Obviously restarting Smokeping
docker restart smokeping

docker exec cacti /createdevices.sh -d -g -f "$DEVFILE"
