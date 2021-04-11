#!/bin/bash

SMOKETARGETS=/docker/smokeping/config/Targets

usage() { echo "Usage: $0 -f <devicefile.csv>" 1>&2; exit 1; }

while getopts ":hf:" opt; do
    case ${opt} in
        f)
            DEVFILE="$OPTARG"
            ;;
        h)
            h=true
	    echo "Usage: $0 -f <devicefile.csv>"
	    exit 0
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

if [ -z $DEVFILE ] && [ -z $h ]; then
    usage
fi

# Remove Windows carriage returns
#tr -d '\r' < $1 > $1

# Place device list in the Cacti container and add devices.
sudo cp "$DEVFILE" /docker/cacti/data/
sudo chmod 600 "/docker/cacti/data/$DEVFILE"
#docker exec cacti /createdevices.sh -d -g -f "$DEVFILE"

echo '

 __   ___       ___  __       ___         __
/ _` |__  |\ | |__  |__)  /\   |  | |\ | / _`
\__> |___ | \| |___ |  \ /~~\  |  | | \| \__>

 __         __        ___  __          __
/__`  |\/| /  \ |__/ |__  |__) | |\ | / _`
.__/  |  | \__/ |  \ |___ |    | | \| \__>

'

# Create blank Smokeping Targets file
docker exec smokeping chmod 666 /config/Targets
sudo echo "*** Targets ***

probe = FPing

menu = Top
title = Network Latency Grapher
remark = Welcome to the MCNC Network Probe Smokeping Server. Here you will learn all about the latency of your network.

" > $SMOKETARGETS

# Add devices to Smokeping
while IFS="," read devicename ipaddress comstring

do
DEVICENAME=$(echo $devicename | sed -r 's/(\W|_)//g')
sudo echo "+ $DEVICENAME
menu = $devicename
title = $devicename ($ipaddress)
host = $ipaddress
" >> $SMOKETARGETS
done < <(tail -n +2 "$DEVFILE")

docker exec smokeping chmod 600 /config/Targets

# Obviously restarting Smokeping
docker restart smokeping

echo '

 __   ___       ___  __       ___         __
/ _` |__  |\ | |__  |__)  /\   |  | |\ | / _`
\__> |___ | \| |___ |  \ /~~\  |  | | \| \__>

             __        __  ___
            /  `  /\  /  `  |  |
            \__, /~~\ \__,  |  |

'

docker cp createdevices.sh cacti:/
docker exec cacti chmod +x /createdevices.sh
docker exec cacti /createdevices.sh -d -g -f "$DEVFILE"
