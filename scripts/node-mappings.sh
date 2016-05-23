#!/usr/bin/env bash

declare -a vm_names=()
declare -a vm_macs=()
declare -a overcloud_names=()
counter=0

user=root
kvmhost=trevally.usersys.redhat.com
undercloud_name=director
provisioning_network=foreman

source ~/stackrc

for i in $(virsh --connect qemu+ssh://${user}@${kvmhost}/system list --all | grep running | awk '{print qc$2qc}' | grep -v ${undercloud_name});
do
#	echo 1
    vm_names=("${vm_names[@]}" $i);
#	echo 2 $vm_names
    mac=$(virsh --connect qemu+ssh://${user}@${kvmhost}/system domiflist $i | grep ${provisioning_network} | awk '{print $5;}');
#	echo 3 $mac
    vm_macs=("${vm_macs[@]}" $mac);
#	echo 4 $vm_macs
    port_id=$(ironic port-list | grep $mac | grep -v 'UUID' | awk '{print $2;}');
#	echo 5 $port_id
    node_id=$(ironic port-show $port_id | grep node_uuid | awk '{print $4;}');
#	echo 6 $node_id
    instance_id=$(ironic node-show $node_id | grep instance_uuid | awk '{print $4;}');
#	echo 7 $instance_id
    over_name=$(nova list | grep $instance_id | awk '{print $4}');
#	echo 8 $over_name
    overcloud_names=("${overcloud_names[@]}" $over_name);
done

for vm in "${vm_names[@]}";
do
    echo "Overcloud Node ${overcloud_names[$counter]} is VM $vm";
    ((counter++));
done
