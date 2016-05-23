#!/bin/bash

if [ x"$#" != x"1" ]; then
	echo "$0 op"
	exit 1
fi
op=$1; shift

case ${op} in
show)
	for f in control compute ceph-storage; do
		openstack flavor show ${f}
	done
	;;
create)
	openstack flavor create --id auto --ram 512 --swap 512 --disk 38 --vcpus 1 baremetal
	openstack flavor create --id auto --ram 1099 --swap 512 --disk 38 --vcpus 2 control
	openstack flavor create --id auto --ram 1099 --swap 512 --disk 38 --vcpus 1 compute
	openstack flavor create --id auto --ram 1024 --swap 512 --disk 38 --vcpus 1 ceph-storage
	for f in control compute ceph-storage; do
		openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="${f}" ${f}
	done
	;;
delete)
	for f in control compute ceph-storage; do
		openstack flavor delete ${f}
	done
	;;
esac
