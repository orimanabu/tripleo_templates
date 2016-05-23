#!/bin/bash

source ~/stackrc

if [ x"$#" != x"1" ]; then
	echo "$0 regexp"
	exit 1
fi
regexp=$1; shift

#openstack server list --name ${regexp} -f csv --quote none -c Name -c Networks | grep -v Name | while IFS=, read name _addr; do
#	echo "=> ${name} / ${addr}"
#done
line=$(openstack server list --name ${regexp} -f csv --quote none -c Name -c Networks | grep -v Name | head -n 1)
name=$(echo ${line} | cut -d, -f1)
addr=$(echo ${line} | cut -d, -f2 | sed -e 's/^ctlplane=//')
echo "=> ${name} / ${addr}"
ssh-keygen -R ${addr}
ssh -o StrictHostKeyChecking=no -l root ${addr}
