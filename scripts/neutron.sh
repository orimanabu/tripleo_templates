#!/bin/bash

if [ x"$#" != x"1" ]; then
	echo "$0 op"
	exit 1
fi
op=$1; shift

tenant=demo
vlanid=199
prefix=10.1.199
prefixlen=24
dhcp_start=100
dhcp_end=199
gateway=${prefix}.1
l3agent_addr=${prefix}.99
network=provider
subnet=provider_subnet
port=provider_port_for_l3agent
router=router_provider

case ${op} in
external)
	source ~/keystonerc_admin
	# external network
	neutron net-create --provider:physical_network datacentre --provider:network_type vlan --provider:segmentation_id 100 --shared --router:external external
	neutron subnet-create external 10.1.1.0/24 --name external_subnet --disable-dhcp --gateway 10.1.1.1 --allocation-pool start=10.1.1.100,end=10.1.1.199
	;;
provider)
	source ~/keystonerc_admin
	# provider network for 'demo' tenant
	tenant_id=$(openstack project list | awk '/'${tenant}'/ {print $2}')
	neutron net-create --provider:physical_network datacentre --provider:network_type vlan --provider:segmentation_id ${vlanid} --tenant-id ${tenant_id} ${network}
	neutron subnet-create ${network} ${prefix}.0/${prefixlen} --name ${subnet} --enable-dhcp --gateway ${gateway} --allocation-pool start=${prefix}.${dhcp_start},end=${prefix}.${dhcp_end} --tenant-id ${tenant_id} --host-route destination=169.254.169.254/32,nexthop=${l3agent_addr} --host-route destination=0.0.0.0/0,nexthop=${gateway}
	neutron router-create ${router}
	neutron port-create --fixed-ip subnet_id=$(neutron subnet-list | awk '/'${subnet}'/ {print $2}'),ip_address=${l3agent_addr} --name ${port} ${network}
	neutron router-interface-add ${router} port=${port}
	;;
vm_provider)
	source ~/keystonerc_${tenant}
	# nova boot for provider network
	nova boot --flavor m1.tiny --key-name sshkey --nic net-id=$(neutron net-list | awk '/'${network}'/ {print $2}') --image cirros vm_provider
	;;
esac
