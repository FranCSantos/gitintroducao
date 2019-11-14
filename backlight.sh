#!/bin/bash
set -e
set -u

if [ $EUID -ne 0 ]; then
        echo 'please run as root'
        exit 1
fi

BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/brightness`
MAX_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/max_brightness`

if [ $# == 0 ]; then
	echo "$BRIGHTNESS/$MAX_BRIGHTNESS"
	exit 0;
fi

if [ $# -ne 1 ]; then
	echo "usage: backlight.sh [brightness]"
	exit 1;
fi


if [[ "$1" =~ ^-?[0-9]+$ ]]; then
	desired="$1"
	[ $1 -gt "$MAX_BRIGHTNESS" ] && desired="$MAX_BRIGHTESS"
	[ $1 -lt 0 ] && desired=0
	echo "$desired" > /sys/class/backlight/intel_backlight/brightness
	echo "$(cat /sys/class/backlight/intel_backlight/brightness)/$MAX_BRIGHTNESS"
else 
	echo "um numero deve ser passado como argumento."
	exit 2
fi
