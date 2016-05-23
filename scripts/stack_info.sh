#!/bin/bash

if [ x"$#" != x"1" ]; then
	echo "$0 rcfile"
	exit 1
fi
rcfile=$1; shift
source ${rcfile}

function do_command {
	local args=$*
	echo "==> ${args}"
	eval ${args}
}

echo "=> from undercloud"

do_command swift stat
do_command swift capabilities
do_command OS_TENANT_NAME=service swift list
do_command OS_TENANT_NAME=service swift list --lh

do_command instack-ironic-deployment --show-profile

do_command nova service-list
do_command nova agent-list
do_command nova host-list
do_command nova hypervisor-list
hv_ids=$(nova hypervisor-list | awk '/enabled/ {print $2}')
for id in ${hv_ids}; do
	do_command nova hypervisor-show ${id}
done

opts=""
if [ x"${OS_TENANT_NAME}" = x"admin" ]; then
	opts="--all-projects"
fi
do_command openstack server list ${opts}
vm_ids=$(openstack server list ${opts} -c ID -f csv --quote none | grep -v ID)
for id in ${vm_ids}; do
	do_command openstack server show ${id}
done

do_command openstack baremetal list
bm_ids=$(openstack baremetal list -c UUID -f csv --quote none | grep -v UUID)
for id in ${bm_ids}; do
	do_command openstack baremetal show ${id}
	do_command openstack baremetal show ${id} --long
	do_command ironic node-show ${id}

#	extra_hardware=$(openstack baremetal show ${id} --long | grep '^| extra' | sed -e "s/^.*u'hardware_swift_object': u'\(.*\)'.*$/\1/")
	extra_hardware="extra_hardware-${id}"
	echo "===> ${extra_hardware}"
	do_command "OS_TENANT_NAME=service swift download --output - ironic-discoverd ${extra_hardware} | python -m json.tool"
done

do_command neutron ext-list
do_command neutron agent-list

do_command neutron net-list
net_ids=$(neutron net-list -c id -f csv --quote none | grep -v id)
for id in ${net_ids}; do
	do_command neutron net-show ${id}
done

do_command neutron subnet-list
subnet_ids=$(neutron subnet-list -c id -f csv --quote none | grep -v id)
for id in ${subnet_ids}; do
	do_command neutron subnet-show ${id}
done

do_command neutron port-list
port_ids=$(neutron port-list -c id -f csv --quote none | grep -v id)
for id in ${port_ids}; do
	do_command neutron port-show ${id}
done

do_command neutron router-list
router_ids=$(neutron router-list -c id -f csv --quote none | grep -v id)
for id in ${router_ids}; do
	do_command neutron router-show ${id}
done

do_command openstack image list
do_command openstack image list --long
do_command glance image-list
image_ids=$(openstack image list -c ID -f csv --quote none | grep -v ID)
for id in ${image_ids}; do
	do_command openstack image show ${id}
done

do_command heat stack-list
do_command heat stack-list --show-nested
do_command heat resource-list -n 5 overcloud


