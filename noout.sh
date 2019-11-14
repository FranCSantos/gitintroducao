#!/bin/bash

if [ $# -eq 0 ]; then
	echo "usage: noout program"
	exit 1;
fi

program="$1"
shift
"$program" "$@" &> /dev/null &
disown
