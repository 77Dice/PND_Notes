# Network setup

## IProute2

> ([iproute2 Howto Wiki](http://www.policyrouting.org/iproute2.doc.html)) offers complete low-level network configuration 

| command | description | 
| --| --|
|ip link \ ip l  | show physical interfaces  |
|ip link set ethx address a:b:c:d:e:f  | set MAC address |
|ip link set ethx [up\down]  | plug-unplug cable  |  			    
|ip addr \ ip a show [dev ethx]  | show ip address  | 
|ip addr [add\del] a.b.c.d/m dev ethx  | add/remove ip address |			    
|ip addr flush [dev ethx]  | remove any assigned address |
|ip addr replace a.b.c.d/m dev ethx  | instead of flush+add during startup   |
|ip route \ ip r [list\flush]  | list\flush routing table |	 
|ip route [add\del] a.b.c.d/m via [next_hop]  | add/del route by next hop|			    
|ip route [add\del] default via a.b.c.d  | add/del default route|
|watch ip r  | real-time populated routing table     |
|ip route [add\del] a.b.c.d/m dev ethx  | Direct forwarding |
|ip neigh [flush\show] dev ethx  | show/flush ARP table |

| ifconfig commands  | for legacy systems     |
| -- |-- |
| ifconfig (-a) [ethx]  | display all active interfaces and details |
|ifconfig \ [ifup\ifdown] $eth_x$  [up\down]  | enable\disable $eth_x$   |	
|ifconfig $eth_x$ a.b.c.d netmask A.B.C.D broadcast e.f.g.h  | config IP of ethx interface |    
| ifconfig ethx hw ether AA:BB:CC:DD:EE:FF  | change MAC address |
| route add default gw a.b.c.d  | set default route gateway  |

| IPv6 Only | --|
| --| --| 
| route -6 | show IPv6 routing table |   
| traceroute\ping a.b.c.d  | test if reachable  |

## kathara files

> - /shared.startup (shell commands for all vm inside kathara lab)
> - /vm.startup (booting command for specific vm)
> - /lab.conf (physical topology and collision domain definition)
> - /vm/etc/network/interfaces (network interfaces file for static IP config)
> - /etc/resolv.conf (contains DNS IP addresses)

## How configure topology of networks

> [Debian Network Setup](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html) | [NetworkManager_cli](https://developer-old.gnome.org/NetworkManager/stable/nmcli.html)

- In order to `properly` use Internet an Host has to receive `4 main pieces` on information:
  - The IP address
  - The netmask (defines Network/host portion of IP address)
  - The IP address of its Default Gateway (device in local network `able to access` the Distribution layer)
  - The IP address of a DNS (a remote server `able to translate` human intelligible names to IP addresses)

> configuration can be `static`: inside */vm/etc/network/interfaces* or at `startup` using *ifconfig* or *iproute2* commands; (ex. on lab1)

## DHCP3 setup

> ([wiki](https://it.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)) It's a client-server mechanism implemented by deamon `dhcpd` where the Server has a `pool` of IP addresses to distribute together with the network configuration


> ![picture 1](../images/1a9b492a3fa704f1822eaf78a1b313c36b34bfdf621602f00273fe8d385cda93.png)  <p align = "center" > 	<em> DHCP address exchange </em> </p>



>  Clients requesting a new IP address receive a proposal and accept it, once accepted the IP is `reserved` for a "leasing time"

- DHCP procedure uses `udp` protocol on port 67(srv) / 68(client):
  - Host broadcast "DHCP Discover"
  - DHCP Srv. responds with "DHCP offer"
  - Host request IP addr "DHCP request"
  - DHCP Srv. sends addr "DHCP ACKNOWLEDGE"

- udhcp configuration:
  1. install package (*apt install -f udhcpd*) inside startup file 
  2. set up *rx/etc/udhcpd.conf* file as shown here: [udhcp.conf-syntax](https://udhcp.busybox.net/udhcpd.conf)
  3. start daemon (*udhcpd /etc/udhcpd.conf*) inside startup file
  4. set up client:
     -  inside *pcy/etc/network/interfaces* file: *iface ethx inet dhcp*
     -  (*dhclient ethx*) inside startup file

## Host Connection Script

works on: lab2/ex1

> how connect `host machine` to `VM` (guest machine)?

> after starting the lab we need to link one collision domain(local net) to a `virtual interface` ($veth_x\ veth_y$)

> we need to find the `docker image` related to the `collision domain` we want to connect : there exists `one for each network` with the same name as defined in the `.lab file`
```bash
sudo ip link del veth1 type veth
sudo ip link add veth1 type veth
sudo ip addr flush veth0
sudo ip addr add [addr/x] dev veth0

# find docker image of local network
sudo docker network list | grep kathara_[user]-xxxx_[lan]
                         | grep kathara_xxx

#bridge = xxx
brctl show | grep kt- # find right virtual-bridge to connect

sudo ip link set veth1 master kt-xxxx                        

sudo ip link set veth0 up
sudo ip link set veth1 up

ip addr show dev veth1
ip addr show dev veth1
-----------------------------
# on host machine ---listening on veth1
~$ tcpdump -ni veth1  

# host already has IPv6 scope address (by default...)
~$ ping fe80::101%veth0 # (only local lan)

# ---speaking through veth0
~$ sudo ip addr add [IPv6Addr/64] dev veth0
ping -I veth0 2001:db8:cafe:2::10x  # (all lab is reachable)

it works...
./connect-lab .sh (a .b. c.d /x) ( lan_name ) # connect to broadcast domain with given IP address
```

## Network Traffic Monitoring

> Packets flow in the network, to capture them use a `network traffic dump tool` like:

- dumpcap/wireshark/tcpdump
-  wireshark and tcpdump can `visualize, save and analyze captured packets`
-  [Promiscuous/monitor mode](https://en.wikipedia.org/wiki/Promiscuous_mode): NIC/WNIC pass all the observable traffic without discrimination to the CPU
- Capturing all the packets can be messy:`use filters!` to focus on specific packets, connection or activity patterns
- `Display filters`: inspect only packets you want to analyse and display packets `matching the filters`, packets are `not discarded or lost` (wireshark)
- `Capture filters`: Limit the traffic captured and analysed. packets not captured `are lost!`(tcpdump)

### How capture Network traffic?

- Promiscuous mode (can be limited by switches)
- Physical tap interface (directly to LAN cable)
- Port mirroring on a managed switch:
  - Usually only destination port receive packets:`SPAN` send all traffic to switch `analyser/sniffer`
- Aggressive approaches for sniffing:
  - ARP cache poisoning (spoofing):steal IP addresses using Unsolicited ARP replies ([ettercap](https://www.ettercap-project.org/),cain¿abel)
  - MAC flooding: fill the CAM Table of switch to make it acting as a hub (macof)
  - DHCP redirection: steal(exhausts) IP addresses from the pool, then pretend to be the default GW with new DHCP requests
  - redirection and interception of ICMP packets


> ![picture 2](../images/fcc0dc172e7049812e32d1c29dc604dd07361106b90239ac458886aa1a949aa5.png)<p align = "center" > 	<em> SPAN-RAP </em> </p>


### How prevent packet capture?

> methods implemented in switches

- `Dynamic address inspection(DAI)`: validates APR packets
- `IP-to-MAC address binding inspection`: drop invalid packets
- `DHCP snooping`: distinguish between trusted and untrusted ports and uses a `database` of IP-to-MAC;
  - ports that show rogue activity can be `automatically disabled`

## Packet inspection with tcpdump

> Dummy example: we connect Host machine using script, then we use `netcat` to create a UDP/TCP connection between 2 host and capture traffic with [tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html) finally visualize it on host machine with wireshark(file.pcap)

|netcat | . | 
|--|--|
|nc (-u) [ip-addr] [port] | TCP/UDP connection through port |
|nc (-u) -l -p [port] | Listen on port |

> when capturing on vm remember to save file.pcap on */shared* folder

| tcpdump | (on listener Host) |
|--|--|
| (ctrl+z) + | (bg) |
| tcpdump -ni [ethx/any] -w /shared/file.pcap | (-n) not resolve DNS (-i) define interface (-w) write on |

|ports check | . |
|--|--|
|ss|TCP sockets & established connections |
| (-l) listening sockets (-u -t -x) udp,tcp,unix | . |
| lsof -P -n -i(IPv4) | info about files opened by proceses |
| netstat | connections states with localhost |
| (-ltn) listening,tcp,no resolve | | 

# ex1 

ex 1...