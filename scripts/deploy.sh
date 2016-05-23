#!/bin/bash

export LANG=C
. ~/stackrc
echo "=> start date"
date

echo "=> overcloud deploy"
time openstack overcloud deploy \
--templates ~/templates/tht \
--ntp-server 10.5.26.10 \
--libvirt-type kvm \
--control-scale 3 \
--compute-scale 2 \
--ceph-storage-scale 1 \
--control-flavor control \
--compute-flavor compute \
--ceph-storage-flavor storage \
--neutron-tunnel-types vxlan \
--neutron-network-type vxlan \
-e ~/templates/storage-environment.yaml \
-e ~/templates/network-isolation-static.yaml \
-e ~/templates/network-environment.yaml \
-e ~/templates/timezone.yaml \
-e ~/templates/all.yaml

#-e ~/templates/ips-from-pool-all.yaml \
#-e ~/templates/scheduler-hints.yaml \
#-e ~/templates/network-isolation.yaml \

#--debug --verbose \

#--neutron-network-vlan-ranges datacentre:800:900 \
#-e ~/templates/environments/network-isolation.yaml \
#-e ~/templates/tht/environments/network-isolation.yaml \

## ceph
#--ceph-storage-scale 1 \
#-e ~/templates/storage-environment.yaml \

## for vxlan
#--neutron-tunnel-types vxlan \
#--neutron-network-type vxlan \

## debug
#-e ~/templates/ceph_osd_setup.yaml \
#-e ~/templates/swap_setup.yaml \
#-e ~/templates/misc_setup.yaml

echo "=> end date"
date
