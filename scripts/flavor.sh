#!/bin/bash

#openstack flavor create --id auto --ram 6144 --swap 512 --disk 38 --vcpus 2 control
#openstack flavor create --id auto --ram 3072 --swap 512 --disk 38 --vcpus 1 compute
#openstack flavor create --id auto --ram 2560 --swap 512 --disk 18 --vcpus 1 storage

for f in control compute storage; do
	openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="${f}" ${f}
done
