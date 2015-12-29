#!/bin/sh

apt-get update
apt-get install -y traceroute

echo "1 std" >> /etc/iproute2/rt_tables
echo "2 anycast" >> /etc/iproute2/rt_tables
tee /etc/network/if-up.d/user <<EOF
#!/bin/sh
ip route delete default
ip route add default via 10.20.1.11
EOF

chmod +x /etc/network/if-up.d/user
/etc/network/if-up.d/user

