
The topology in this experiment demonstrates anycast based loadbalancing using a set of BGP 
peered routers, servers, and clients. All the routers use Quagga for BGP.

## Prerequisites

1. Vagrant
2. Cumulus Linux: Follow steps at [Setting Up the Vagrant Environment](https://docs.cumulusnetworks.com/display/VX/Using+Cumulus+VX+with+Vagrant#UsingCumulusVXwithVagrant-SettingUptheVagrantEnvironment)
to download and add Cumulus Linux vagrant box.

I use Cumulus Linux as support for flow based multipath routing is lacking in kernels shipped 
with commodity Linux distros. 

## Getting Started

```
git clone https://github.com/s3u/vagrant-anycast-bgp.git
cd vagrant-anycast-bgp
vagrant up
```
Due to a bug in Cumulus Linux 2.5.5, make the following change.

1. `vagrant ssh cr1`
2. `sudo vi sudo vi /etc/network/interfaces`
3. Add `netmask 255.255.255.0` for interfaces `swp1`, `swp2`, `swp3`.
4. `sudo service networking restart`

Wait for a few seconds to get the routing table updated.

```
vagrant@cr1:~$ ip ro
default via 10.0.2.2 dev eth0
10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15
10.10.12.0/24 dev swp2  proto kernel  scope link  src 10.10.12.11
10.10.13.0/24 dev swp3  proto kernel  scope link  src 10.10.13.11
10.20.1.0/24 dev swp1  proto kernel  scope link  src 10.20.1.11
10.20.2.0/24 via 10.10.12.12 dev swp2  proto zebra  metric 20
10.20.3.0/24 via 10.10.13.13 dev swp3  proto zebra  metric 20
10.30.1.3  proto zebra  metric 20
	nexthop via 10.10.12.12  dev swp2 weight 1
	nexthop via 10.10.13.13  dev swp3 weight 1
```

## Topology

The above steps bring up The topology in this example consists of the following:

1. cr1: A Cumulus 2.5.5 router that client nodes u1 and u2 connect to. 
2. r2 and r3: Two Ubuntu 14.04 routers peering with cr1 via BGP.
3. s1: Server with anycast IP of `10.30.1.3` with r2 as the default gateway.
4. s2: Server with anycast IP of `10.30.1.3` with r3 as the default gateway.

Both s1 and s2 run nginx that prints the hostname in response to a `GET`.

## Tests

Open two terminals and try the following in each.

```
# Terminal 1
vagrant ssh u1 -c "while true; do curl 10.30.1.3;done"

# Terminal 2
vagrant ssh u2 -c "while true; do curl 10.30.1.3;done"
```

Note these two printing `s1` or `s2` in a loop.

While this is going on, suspend r2.

```
vagrant suspend r2
```

Both terminals start printing `s2` as `s1` is no longer reachable. Then resume r2 and suspend r3 to see both terminals
print `s1`.

## Credits

This setup is a fork of [https://github.com/d-adler/vagrant-anycast-bgp](https://github.com/d-adler/vagrant-anycast-bgp),
 but extended to demonstrate multipath routing for load banalcing.
