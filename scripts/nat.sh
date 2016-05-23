#!/bin/bash

iptables -t nat -I BOOTSTACK_MASQ 1 -s 10.1.1.0/24 -j MASQUERADE
iptables -vnL -t nat
