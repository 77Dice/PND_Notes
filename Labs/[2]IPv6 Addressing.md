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

> ([interfaces MAN Page](https://manpages.debian.org/stretch/ifupdown/interfaces.5.en.html)) we can configure both GUA and Link local addresses just adding `inet6` inside *pcx/etc/network/interfaces*
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
sysctl (path)  ##show flag value
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

1. router as before : static
   1. inoltre `deve avere ::1 su ogni addr` il router 
   2. posso definire DOMAIN NAME + DNS inside interfaces file
   3. OKOKOKOKOKOKOKOKOKOK
2. flags as before : SLAAC + R1 IS STATIC 
   1. OKOKOKKOKOKOK
   
3. adesso devo usare DNSMASQ al posto di RADVD per IPv4+6 (route + DNS + prefix )
   > [MAN_Page_dnsMasq](https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html#index) :: is a `lightweight` DNS,router advertisement and DHCPv4-v6 server

  - first install DNSMASK by pkg
```bash
... how install inside startup 
###okokokokokokok
```
- when starts it read ***/etc/dnsmasq.conf*** if exists
  - inside there are all explanations and commands to define Autoconfiguration
  - [example_dnsmasq.conf](https://github.com/imp/dnsmasq/blob/master/dnsmasq.conf.example) : `every row has comment, for every service of DNSMASQ`; 
    - to enable just uncomment specific row!!
    - and override it at startup!!!
```bash
## configuration ????????????  have copy on SAMPLE.conf
...
```
   - per far partire dnsmasq: 
```bash
dnsmasq --test #(!=0 if something Wrong)
dnsmasq -d (debug mode) -k(run as normal)

## nononononono
# non parte sulla porta 53... non posso usarlo come DNS server!!
```

4. adesso devo configurare i Clients per IPv4+6
    > [DIBBLER](https://klub.com.pl/dhcpv6/doc/dibbler-user.pdf)

### dibbler-client

> ([man_dibbler-Client](https://www.systutorials.com/docs/linux/man/8-dibbler-client/)) is a portable implementation of the `DHCPv6 client` 
1. we need to download package and install it on host VM
    ```bash
    # dibbler-client_1.0.1-1+b1_amd64.deb
    dpkg -i /shared/dibbler-client*.deb
    apt install -y dibbler-client
    ```
2. we `configure it` by **/pcx/etc/dibbler/client.conf** file
   ```bash
   awdwa

   ```
3. start it

 dibber-client start

just follow instructions inside **pcx/etc/dibbler/client.conf

or >> dibbler-client status for information


### EX3

> GOAL: to configure the topology to use dynamic IPv6 addresses. You have to use `SLAAC+DHCPv6` to provide GUA addresses: `It is a stateless dynamic addressing`

> we have IPv4 + IPv6 network , 1 client for each version
1. set flags
2. set daemons 
3. set clients 
  
You have to properly set up the addresses of r1 and dnmasq
and to properly set up the pc configurations.

- lan has the subnet 2001:DB8:FEDE:1::/64 and 192.168.100.0/24
- you can also setup the domain name (es: netsec.local)
- r1 uses as DNS servers 8.8.8.8 and 2001:4860:4860::8888
 
- pc1 and pc2 must obtain the address via SLAAC and the DNS+domain
  info via stateless DHCPv6

- pc1 has to use dibbler-client
  -- you can install it using dpkg -i /shared/dibbler-client*

- pc2 has to use dhclient 

- the router has always 1 in the host part of its own address 
  even in its local-link address.






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

- route is working and also ping over networks

# General - references

[HOWTO-GUIDE-IPv6](https://tldp.org/HOWTO/Linux+IPv6-HOWTO/index.html)

[IPv6 ROUTES](https://tldp.org/HOWTO/Linux+IPv6-HOWTO/ch07.html)


