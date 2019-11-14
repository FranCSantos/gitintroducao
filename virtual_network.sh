#!/bin/bash
set -e
set -u
set -x

if [ $EUID -ne 0 ]; then
	echo 'please run as root'
	exit 1
fi

tear_down()
{
	ip netns list | grep -Eq "^red( \(id:.*\))?$" && ip netns del red
	ip netns list | grep -Eq "^blue( \(id:.*\))?$" && ip netns del blue
	:
}

tear_down
trap tear_down ERR SIGINT SIGTERM

# setup virtual devices
ip netns add blue
ip netns add red
ip link add vethr type veth peer name veth1 netns red
ip link add vethb type veth peer name veth1 netns blue
#ip -all netns exec ip link

# setup static addresses
ip addr add 10.0.0.1/28 dev vethr
ip addr add 10.0.0.17/28 dev vethb
ip netns exec red ip addr add 10.0.0.2/28 dev veth1
ip netns exec blue ip addr add 10.0.0.18/28 dev veth1
#ip -all netns exec ip addr

# activate interfaces
ip link set vethr up
ip link set vethb up
ip netns exec red ip link set veth1 up
ip netns exec blue ip link set veth1 up

# enable forwarding and add routes
sysctl -w net.ipv4.ip_forward=1
ip route
ip netns exec red ip route add default via 10.0.0.1 dev veth1
ip netns exec blue ip route add default via 10.0.0.17 dev veth1
#ip route

#test
ping -c1 10.0.0.2
ip netns exec red ping -c1 10.0.0.1
ping -c1 10.0.0.18
ip netns exec blue ping -c1 10.0.0.17


