sudo ip link add link eth5 name eth5.internal type vlan id 201
sudo ip link set up eth5.internal
sudo ip addr add 172.16.0.200/24 dev eth5.internal

sudo ip link add link eth5 name eth5.external type vlan id 100
sudo ip link set up eth5.external
sudo ip addr add 10.1.1.200/24 dev eth5.external
