# References

> [HOWTO_IPv6](https://tldp.org/HOWTO/Linux+IPv6-HOWTO/index.html)

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

> ([interfaces man_Page](https://manpages.debian.org/stretch/ifupdown/interfaces.5.en.html)) we can configure both GUA and Link local addresses just adding `inet6` inside *pcx/etc/network/interfaces*
```bash
## remember tabs!!
auto eth0
iface eth0 inet6 static
  address fe80::101
  netmask 64
  gateway fe80::1
  dad-attempts 0

iface eth0 inet6 static
  address	2001:DB8:CAFE:1::101
  netmask	64
  gateway	2001:DB8:CAFE:1::1
  dad-attempts 0
  dns-domain net.local
  dns-nameservers 2001:4860:4860::8888
```
then we need to manually enable interfaces inside *pcx.startup*
```bash
## only for interface configuration 
ifup -a
ifquery -l
## route add
ip -6 route add default via fe80::1 dev eth0 
#ip -6 route add 2001:db8:cafe:2::/64 via fe80::1 dev eth0
```

# IPv6 IpRoute2 Configuration

| ipRoute2 | --|
| --| --| 
|ip -6 addr add (ll-GUA)/64 dev ethx| add IPv6 Unicast address|
|ip -6 addr add `scope link` fe80::1/64 dev ethx | add Link-local address|
|ip -6 route add default via (`ll`) dev ethx|add default route via link local|
|ip -6 route add 2001:db8:cafe:1::/64 dev ethx|add route|
|ip -6 route show | show IPv6 routing table|
> Default gw `is always a link-local` address. This address is also used for `Router Solicitation-Advertisement`

|ifconfig|--|
|--|--|
|ifconfig ethx inet6 add (ll-GUA)/64| add IPv6 Unicast address |
|route -A inet6 (add\del) default gw (`ll`) dev ethx| add default route via Link Local|
|route -A inet6 add 2001:db8:cafe:1::/64 dev ethx| add Route|
| route -6 | show IPv6 routing table |

|How ping IPv6||
|--|--|
|ping (GUA) | Works!! |
|ping -6 fe80::10x%ethx | ONLY ONE that works for link local destinations|
|ping -6 fe80::10x -I ethx|works for GUA + link local destinations|

# SLAAC Configuration

## Network Flags (sysctl)

> ([sysctl-flags](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)) flags for `low level configuration` inside linux (like windows registers)

> inside **/proc/sys/`net`/ipv6/conf/(all-$eht_x$)**  we have network flags for IPv6 interfaces configuration

they can be set on */lab.conf* file :
```bash
...
pcx[sysctl]= "net.ipv6.conf.all.(flag_name) = (value)"
r1[sysctl]= "net.ipv6.conf.all.accept_ra=0"
...
```
on *startup file* only on `privileged mode` :
```bash
sysctl -w net.ipv6.conf.all.(flag_name) = (boolean/number)
sysctl (dot-notation variable)  ##show flag value
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
|..|1-> DO NOT generate link-local + EUI-64 for autoconf addr|
|..|2-> generate `stable privacy addresses` using stable secret ([RFC7217](https://datatracker.ietf.org/doc/html/rfc7217)) - balance privacy and stability|
|..|3-> generate `stable privacy addresses` using random secret|
|.stable_secret|IPv6 addr - this address will be used as `secret` to generate IPv6 addr for link local and autoconf ones|
|..|Writes to conf/all/stable_secret are refused ; It is recommended to generate this secret `during startup` and `keep it stable` after that|
|.use_tempaddr|preference for `Privacy Extensions`|
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

## Router Advertisement Daemon

> ([quick-radvd](https://www.linuxtopia.org/online_books/network_administration_guides/Linux+IPv6-HOWTO/hints-daemons-radvd.html)) in order to activate SLAAC autoconfiguration the default IPv6 Gateway Router needs to enable the `daemon` delegated to manage the Autoconfigration via RA-RS messages

- ([radvd.conf](https://manpages.debian.org/testing/radvd/radvd.conf.5.en.html)) */etc/radvd.conf* file : 
```
interface ethx { 
        AdvSendAdvert on;
        MinRtrAdvInterval 3; 
        MaxRtrAdvInterval 10;
        prefix prefix/length { 
                AdvOnLink on; 
                AdvAutonomous on; 
                AdvRouterAddr on; 
        };
        route prefix/length {
	            ## list of route specific options
        };        
};
```
- */rx.startup* file :
```bash 
## static config ...
ifup eth0
ifup eth1
...
## download and START RA-daemon
dpkg -i radvd_1%3a2.15-2_amd64.deb
radvd -m logfile -l /var/log/radvd.log
```

# SLAAC + DHCPv6 Stateless Configuration

## DNSMASQ 
> ([man_Page](https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html#index)) is a `lightweight` DNS, router advertisement and DHCPv4-6 server

when starts, DNSMASQ reads configuration options inside ***/etc/dnsmasq.conf*** file
>  - ([dnsmasq.conf](https://github.com/imp/dnsmasq/blob/master/dnsmasq.conf.example)) :: `for every service of DNSMASQ we have comments and descriptions` 
>   - to enable an option just uncomment specific row

some available options inside `/etc/dnsmasq.conf` :
```bash
# If you don't want dnsmasq to read /etc/resolv.conf or any other
# file, getting its servers from this file instead (see below), then
# uncomment this.
no-resolv

# Add other name servers here, with domain specs if they are for
# non-public domains.
server=/localnet/192.168.0.1

# If you want dnsmasq to listen for DHCP and DNS requests only on
# specified interfaces (and the loopback) give the name of the
# interface (eg eth0) here.
# Repeat the line for more than one interface.
interface=ehtx

# If you want dnsmasq to provide only DNS service on an interface,
# configure it as shown above, and then use the following line to
# disable DHCP and TFTP on it.
no-dhcp-interface=ethy

# Set the domain for dnsmasq. this is optional, but if it is set, it
# does the following things.
# 1) Allows DHCP hosts to have fully qualified domain names, as long
#     as the domain part matches this setting.
# 2) Sets the "domain" DHCP option thereby potentially setting the
#    domain of all systems configured by DHCP
# 3) Provides the domain part for "expand-hosts"
domain=netsec.local

# Send DHCPv6 option. Note [] around IPv6 addresses.
dhcp-option=option6:dns-server,[1234::77],[1234::88]

# Send DHCPv6 option for namservers as the machine running 
# dnsmasq and another.
dhcp-option=option6:dns-server,[::],[1234::88]

# Uncomment this to enable the integrated DHCP server, you need
# to supply the range of addresses available for lease and optionally
# a lease time. If you have more than one network, you will need to
# repeat this for each network on which you want to supply DHCP
# service.
dhcp-range=192.168.0.50,192.168.0.150,12h

# Enable DHCPv6. Note that the prefix-length does not need to be specified
# and defaults to 64 if missing/
dhcp-range=1234::2, 1234::500, 64, 12h

# Do stateless DHCP, SLAAC, and generate DNS names for SLAAC addresses
# from DHCPv4 leases.
dhcp-range=1234::, ra-stateless, ra-names

# Set the DHCP server to authoritative mode. In this mode it will barge in
# and take over the lease for any client which broadcasts on the network,
# whether it has a record of the lease or not. This avoids long timeouts
# when a machine wakes up on a new network. DO NOT enable this if there's
# the slightest chance that you might end up accidentally configuring a DHCP
# server for your campus/company accidentally. The ISC server uses
# the same option, and this URL provides more information:
# http://www.isc.org/files/auth.html
dhcp-authoritative

# Include all files in a directory which end in .conf
conf-dir=/etc/dnsmasq.d/,*.conf
```
usually we `don't modify` this file but instead create a new file : `/etc/dnsmasq.d/,*.conf` were we enable all configuration options we need
- this folder must be enable inside dnsmasq.conf
- always check syntax with `$ dnsmasq --test`
- EXAMPLE of [dnsmasq_Configuration](https://www.tecmint.com/setup-a-dns-dhcp-server-using-dnsmasq-on-centos-rhel/)
```bash
# test configuration file syntax
dnsmasq --test 
# start dnsmasq
dnsmasq -d (debug mode) -k(run as normal) -p(def listening port)
# restart on the run
systemctl restart dnsmasq 
```

## Dibbler Client

> ([man_Page](https://manpages.debian.org/testing/dibbler-client/dibbler-client.8.en.html)) is a portable implementation of the `DHCPv6 client`

we configure client inside ***/etc/dibbler/client.conf*** file
>  - ([DIBBLER-portable guide](https://klub.com.pl/dhcpv6/doc/dibbler-user.pdf)) :: as for dnsmasq also for dibbler configuration files `for every option we have comments and descriptions` 
>   - to enable an option just uncomment specific row

general `/etc/dibbler/client.conf` file :

```bash
# Defaults for dibbler-client.
# installed at /etc/dibbler/client.conf by the maintainer scripts

# 8 (Debug) is most verbose. 7 (Info) is usually the best option
log-level 7

# To perform stateless (i.e. options only) configuration, uncomment
# this line below and remove any "ia" keywords from interface definitions
stateless

iface eth0 {
# ask for address
#      ai
# ask for options
    option dns-server
    option domain
#    option ntp-server
#    option time-zone
#    option sip-server
#    option sip-domain
#    option nis-server
#    option nis-domain
#    option nis+-server
#    option nis+-domain
}
```
```bash
# check status
dibbler-client status
# start/stop daemon
dibbler-client start/stop
```

# prefix delegation + MTU + ex4-5-6


### EX1

> GOAL: to configure the topology to use static IPv6 addresses.You have to provide static GUA addresses to the machines in the topology, `both link-local and GUA`

- Insert IPv6 information inside interfaces file
- use pcx.startup for enable interfaces and create routes
  - remember to `flush` past address inside startup:
~~~~bash
## first thing first
ip addr flush ethx
## legacy only
/etc/init.d/networking restart
...
echo "nameserver 8.8.8.8" > /etc/resolv.conf
...
~~~~
- Use IProute2 commands for configure addresses + routes inside others VMs
  - remember to add `at least one scope link` + GUA

### EX2

> GOAL: to configure the topology to use `SLAAC IPv6 addresses`. The router is already configured to
advertise prefixes in both the lans

You should check the sysctl ipv6 settings

**Sysctl write can only be done in the lab.conf OR in a priviledged container**

1. RA daemon + router flags already set
2. set pcx flags in lab.conf 
   1. pc1+3:default-EUI64 / pc2:random ID / pc4:random ID+ Privacy extensions;
   ```bash
   ## lab.conf
   ...
    r1[sysctl]="net.ipv6.conf.all.forwarding=1"
    # accept RS only
    r1[sysctl]="net.ipv6.conf.all.accept_ra=0" 
   ...
   ## all pcx accepts RA
   pcx[sysctl]="net.ipv6.conf.all.forwarding=0"
   pcx[sysctl]="net.ipv6.conf.all.accept_ra=1"
   ...
   ## addr_gen_mode  
    # default : EUI-64 + LL
    pc1[sysctl]="net.ipv6.conf.all.addr_gen_mode=0"

    # random Int ID
    pc2[sysctl]="net.ipv6.conf.all.addr_gen_mode=3"

    # EUI-64 + NO LL
    pc3[sysctl]="net.ipv6.conf.all.addr_gen_mode=2"

    # random Int ID + use privacy extensions + shorter lifetime
    pc4[sysctl]="net.ipv6.conf.all.addr_gen_mode=3"
    pc4[sysctl]="net.ipv6.conf.all.use_tempaddr=2"
    pc4[sysctl]="net.ipv6.conf.all.temp_valid_lft=120"
   ```
3. start radvd-DAEMON `on RUNTIME and capture` with tcpdump
   ```bash
   tcpdump -ni ethx -w /shared/capture.pcap
   ## start on runtime
   radvd -m logfile -l /var/log/radvd.log
   ```

- route is working and also ping over networks OKOKOK

### EX3

> GOAL: to configure the topology using `SLAAC+DHCPv6` to provide GUA addresses

***It is a stateless dynamic addressing***

1. configure router/gw as SLAAC (static) by interfaces file
   - `::1` on every IPv6 addr
   - define [domain + DNS] inside interfaces file
2. flags as SLAAC 
```bash
#Router is STATICALLY configured inside interfaces file
r1[sysctl]="net.ipv6.conf.eth0.autoconf=0"
...
pcx[sysctl]="net.ipv6.conf.all.accept_ra=1"
pcx[sysctl]="net.ipv6.conf.all.addr_gen_mode=0"
...
```
3. use `DNSMASQ` instead of RADVD 
   - options configured : route + DNS + prefix + IPv4 + stateless
     1. install it 
     2. configure ***/etc/dnsmasq.conf*** file:
        ```bash
        no-resolv
        interface=eth0
        domain=netsec.local
        server=8.8.8.8
        server=2001:4860:4860::8888
        server=/netsec.local/fe80::1
        #no need for netmask
        dhcp-range=192.168.100.2,192.168.100.254,12h
        #default 64
        dhcp-range=2001:DB8:FEDE:1::, ra-stateless, ra-names
        dhcp-authoritative
        ```
        3.test it
        ```bash
        dnsmasq --test
        ```
        4.start it !!

4. `DNSMASQ` Clients
   - pc2 with dhclient (ipv4) 
   - pc1 uses `DIBBLER-CLIENT`:
     - configure it and start daemon!
        ```bash
        log-level 7
        stateless

        iface eth0 {
            option dns-server
            option domain
        }
        ```
        ```bash
        dibbler-client start
        ```
        