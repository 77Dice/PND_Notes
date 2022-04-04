# Privileges

1. enable IPv6 on kathara settings
2. start lab VMs with privileges or by bash script:
```bash
#!/bin/bash
xrdb ../.XDefaults
sudo kathara lstart --privileged
for p in pc1 pc2 pc3 pc4
do
  xterm -e bash -c "kathara connect $p" &
done
xrdb ../.XDefaults.alt
xterm -e bash -c "kathara connect r1" &
```

# IPv6 static configuration

> we can configure both GUA and Link local addresses just adding `inet6` inside *pcx/etc/network/interfaces*
```
auto eth0
iface eth0 inet6 static
	address	fe80::101
	netmask 64
	gateway fe80::1
	
iface eth0 inet6 static
	address	2001:DB8:CAFE:1::101
	netmask	64
	gateway	2001:DB8:CAFE:1::1
```
then we need to manually starts interfaces and define routes inside *pcx.startup*
```bash
## only for interface configuration 
ifup -a
ifquery -l
## route add
ip -6 route add default via fe80::1 dev eth0 
#ip -6 route add 2001:db8:cafe:2::/64 via fe80::1 dev eth0
```

# IPv6 Startup file Configuration

| ipRoute2 | --|
| --| --| 
|ip -6 addr add (ll-GUA)/64 dev $eth_x$| add IPv6 Unicast address|
|ip -6 addr add `scope link` fe80::1/64 dev $eth_x$ | add Link-local address|
|ip -6 route add default via (`ll`) dev $eth_x$|add default route via link local|
|ip -6 route add 2001:db8:cafe:1::/64 dev $eth_x$|add route|
|ip -6 route show | show IPv6 routing table|
> Default gw `is always a link-local` address. This address is also used for `Router Solicitation-Advertisement`

|ifconfig|--|
|--|--|
|ifconfig $eth_x$ inet6 add (ll-GUA)/64| add IPv6 Unicast address |
|route -A inet6 (add\del) default gw (`ll`) dev $eth_x$| add default route via Link Local|
|route -A inet6 add 2001:db8:cafe:1::/64 dev $eth_x$| add Route|
| route -6 | show IPv6 routing table |

|How ping IPv6||
|--|--|
|ping (GUA) | Works!! |
|ping -6 fe80::10x%ethx | ONLY ONE that works for link local destinations|
|ping -6 fe80::10x -I $eth_x$|works for GUA + link local|

# SLAAC Stateless Configuration

## Network Flags (sysctl)

> ([sysctl-flags](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)) We need to introduce some flags for `low level configuration` inside linux (like windows registers)

> inside **/proc/sys/`net`/ipv6/conf/(all-$eht_x$)**  we have network flags for IPv6 interfaces configuration

they can be set on */lab.conf* file :
```bash
...
pcx[sysctl]= "net.ipv6.conf.all.(flag_name) = (value)"
r1[sysctl]= "net.ipv6.conf.all.accept_ra=0"
...
```
on *startup file* or on the run only on `privileged mode` :
```bash
sysctl -w net.ipv6.conf.all.(flag_name) = (boolean/number)
```
|Used Flags| net.ipv6.conf.all.*|
|--|--|
|.forwarding|boolean - behave like a Router - packets received on this interfaces can be forwarded|
|.accept_ra|Accept RA and `enable autoconfiguration` using them|
|..|0-> Do not accept RA (static Addr Routers)|
|..|1-> Accept RA if .forwarding is disabled (for $pc_x$ that uses SLAAC)|
|..|2-> Overrule forwarding behaviour|
|.addr_gen_mode|define `how` link-local and autoconf `addr are generated`|
|..|0-> EUI-64 (default)|
|..|1-> DO NOT generate ll + EUI-64 for autoconf addr|
|..|2-> generate `stable privacy addresses` using stable secret ([RFC7217](https://datatracker.ietf.org/doc/html/rfc7217))|
|..|3-> generate `stable privacy addresses` using random secret|
|.use_tempaddr|preference for Privacy Extensions|
|..|<=0 : disable privacy extensions (default)|
|..|==1 : enable + prefer public over temporary addr|
|..|>1  : enable + prefer temporary over public addr|
|..|==-1: for `point-to-point,loopback` devices|
|.temp_valid_lft|`valid Lifetime` (in seconds) for `temporary addr` (604800 - 7 days)|
|.temp_prefered_lft|`preferred lifetime` (in seconds) for `Temporary addr`|
|.accept_ra_pinfo|boolean - Learn `prefix information` in RA|
|..|enabled if .accept_ra is enabled|
|..|disabled if .accept_ra is disabled|
|.autoconf|boolean - Autoconfigure address using `prefix information` in RA|
|..|enabled if .accept_ra_pinfo is enabled|
|..|disabled if .accept_ra_pinfo is disabled|

### EX1

> GOAL: to configure the topology to use static IPv6 addresses.You have to provide static GUA addresses to the machines in the topology, `both link-local and GUA`

- Insert IPv6 information inside interfaces file
- use pcx.startup for enable interfaces and create routes
  - remember to `flush` past address inside startup:
```bash
## first thing first
ip addr flush ethx
## legacy only
/etc/init.d/networking restart
...
echo "nameserver 8.8.8.8" > /etc/resolv.conf
...
```
- Use IProute2 commands for configure addresses + routes inside others VMs
  - remember to add `at least one scope link` + GUA

### EX2

> GOAL: to configure the topology to use `SLAAC IPv6 addresses`. The router is already configured to
advertise prefixes in both the lans

You should check the sysctl ipv6 settings

Sysctl write can only be done in the lab.conf OR in a priviledged container

1. 
- All the pcs of the topology must have GUA addresses.

- pc1, pc2 and pc3 have to use standard address.

- pc1 has to use the default configuration for the Interface ID

- pc2 has to use a Random Interface ID

- pc3 has to use EUI-64

- pc4 has to use the privacy extension in order to make it use
  temporary addresses. Set up a short lifetime in order to see multiple 
  addresses. 

- router r1 is already set up. You only have to turn on the radvd server
  to capture the router advertisement packets. See the r1.startup file.

# reference links

[HOWTO-GUIDE-IPv6](https://tldp.org/HOWTO/Linux+IPv6-HOWTO/index.html)

[IPv6 ROUTES](https://tldp.org/HOWTO/Linux+IPv6-HOWTO/ch07.html)


[radvd](https://manpages.debian.org/testing/radvd/radvd.conf.5.en.html)

[radvd2](https://www.linuxtopia.org/online_books/network_administration_guides/Linux+IPv6-HOWTO/hints-daemons-radvd.html)

[dhcpv6BIBLE](https://klub.com.pl/dhcpv6/doc/dibbler-user.pdf)

[DNSMASQ](https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html#index)
