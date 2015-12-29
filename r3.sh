#!/usr/bin/env bash
apt-get update
apt-get install -y quagga
apt-get install -y traceroute

touch /etc/quagga/zebra.conf
chown quagga.quagga /etc/quagga/zebra.conf
chmod 640 /etc/quagga/zebra.conf
echo "password password" >> /etc/quagga/zebra.conf

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
password zebra

router bgp 65003
bgp router-id 10.20.2.13
network 10.20.3.0/24
network 10.30.1.3/32

timers bgp 2 4

neighbor 10.10.13.11 remote-as 65001

log file /var/log/quagga/bgpd.log
EOF

sysctl -w net.ipv4.ip_forward=1
sudo service quagga restart




