#!/bin/bash

usage() { echo "Usage: $0 [-g] [-d] -f <devicefile.csv>" 1>&2; exit 1; }

while getopts ":dgf:" opt; do
  cd /cacti
  case ${opt} in
    f)
      DEVLIST="$OPTARG"
      ;;
    d)
      DEVICES=true
      ;;
    g)
      GRAPHS=true
      ;;
    /?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

cd /cacti

if [ -z $DEVLIST ]; then
  usage
fi

if [ -z $DEVICES ] && [ -z $GRAPHS ]; then
  usage
fi

if [[ $DEVICES = true ]]; then
  while IFS="," read devname ipaddr comstring; do
    php cli/add_device.php --description=$devname --ip=$ipaddr --community=$comstring --template=2 --version=2 --site=0 --avail=ping --ping_method=icmp;
  done < <(tail -n +2 /cacti/$DEVLIST)
fi

if [[ $GRAPHS = true ]]; then
  for i in $(php cli/add_graphs.php --list-hosts | awk '$3 ~ /2/ { print $1 }'); do
    php cli/add_graphs.php --host-id="$i" --graph-type=ds --graph-template-id=42 --snmp-query-id=4 --snmp-query-type-id=21 --snmp-field=ifOperStatus --snmp-value=Up;
  done
fi
