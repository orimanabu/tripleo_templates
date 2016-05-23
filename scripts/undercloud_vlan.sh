#!/bin/bash

#ip link add link eth5 name vlan202 type vlan id 202; sudo ip link set up vlan202
#ip link add link eth5 name vlan203 type vlan id 203; sudo ip link set up vlan203
#ip link add link eth5 name vlan204 type vlan id 204; sudo ip link set up vlan204
#ip link add link eth5 name vlan201 type vlan id 201; sudo ip link set up vlan201

ip addr add 172.16.201.1/24 dev vlan201
ip addr add 172.16.202.1/24 dev vlan202
ip addr add 172.16.203.1/24 dev vlan203
ip addr add 172.16.204.1/24 dev vlan204
