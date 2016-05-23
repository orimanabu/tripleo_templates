#!/bin/bash

export LANG=C
source ~/stackrc
while true; do
	heat stack-list --show-nested
#	heat stack-list --show-nested | grep -v COMPLETE
	date
	sleep 1
done
