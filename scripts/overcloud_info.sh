#!/bin/bash

source ~/stackrc

function do_command {
	local args=$*
	echo "==> ${args}"
	eval ${args}
}

acontroller=""
sshopts="-o StrictHostKeyChecking=no"
#openstack server list -c ID -c Name -c Networks -f csv --quote none | grep -v ID | tr ',' ' ' | while read id name net; do
for line in $(openstack server list -c ID -c Name -c Networks -f csv --quote none | grep -v ID); do
	id=$(echo ${line} | cut -d, -f1)
	name=$(echo ${line} | cut -d, -f2)
	net=$(echo ${line} | cut -d, -f3)
	addr=$(echo ${net} | sed -e 's/ctlplane=//')
	echo "=> ${addr}, ${name}, ${id}"
	do_command ssh ${sshopts} -l root ${addr} ip addr show
	do_command ssh ${sshopts} -l root ${addr} ip -d link show
	do_command ssh ${sshopts} -l root ${addr} ovs-vsctl show
	for br in br-int br-ex br-tun; do
		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl show ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-tables ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-table-features -O OpenFlow13 ${br}
		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-ports ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-ports-desc ${br}
		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-flows ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-aggregate ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl queue-stats ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-groups -O OpenFlow11 ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-group-features -O OpenFlow12 ${br}
#		do_command ssh ${sshopts} -l root ${addr} ovs-ofctl dump-group-stats -O OpenFlow11 ${br}
	done
	for ns in $(ssh ${sshopts} -l root ${addr} ip netns); do
		do_command ssh ${sshopts} -l root ${addr} ip netns exec ${ns} ip a
	done
done

acontroller=$(openstack server list -c Name -c Networks -f csv --quote none | grep controller | sed -e 's/^.*ctlplane=//' | head -n 1)
do_command ssh ${sshopts} -l root ${acontroller} pcs status
do_command ssh ${sshopts} -l root ${acontroller} pcs resource show --full
do_command ssh ${sshopts} -l root ${acontroller} pcs constraint show --full
do_command ssh ${sshopts} -l root ${acontroller} pcs config
