#!/usr/bin/env bash

touch /etc/quagga/zebra.conf
chown quagga.quagga /etc/quagga/zebra.conf
chmod 640 /etc/quagga/zebra.conf
echo "password password" >> /etc/quagga/zebra.conf

# Enable zebra and bgpd
tee /etc/quagga/daemons <<EOF
zebra=yes
bgpd=yes
ospfd=no
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no
EOF

tee /etc/quagga/bgpd.conf <<EOF
hostname bgpd
password password

router bgp 65001
maximum-paths 64
bgp bestpath as-path multipath-relax

bgp router-id 10.20.1.11
network 10.10.12.0/24
network 10.10.13.0/24
network 10.20.1.0/24

timers bgp 2 4

neighbor 10.10.12.12 remote-as 65002
neighbor 10.10.12.12 weight 100
neighbor 10.10.12.12 activate
neighbor 10.10.13.13 remote-as 65003
neighbor 10.10.13.13 weight 100
neighbor 10.10.13.13 activate

log file /var/log/quagga/bgpd.log
EOF

sysctl -w net.ipv4.ip_forward=1
service quagga restart
