#!/bin/sh

apt-get update
apt-get install -y traceroute

echo "1 std" >> /etc/iproute2/rt_tables
echo "2 anycast" >> /etc/iproute2/rt_tables

tee /etc/network/if-up.d/anycast <<EOF
#!/bin/sh
ip route add 10.20.2.0/24 dev eth1 src 10.20.2.100 table std
ip route add default via 10.20.2.12 dev eth1 table std
ip rule add from 10.20.2.100/32 table std
ip rule add to 10.20.2.100/32 table std

ip route add 10.30.1.0/24 dev eth2 src 10.30.1.3 table anycast
ip route add default via 10.30.1.2 dev eth2 table anycast
ip rule add from 10.30.1.3/32 table anycast
ip rule add to 10.30.1.3/32 table anycast
EOF
chmod +x /etc/network/if-up.d/anycast
/etc/network/if-up.d/anycast
ping -c 1 10.30.1.2

apt-get install -y nginx
echo "s1" > /usr/share/nginx/html/index.html