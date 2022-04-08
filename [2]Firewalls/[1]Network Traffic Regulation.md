# Network Traffic Regulation

> [o'reilly_Building_Internet_Firewalls](http://litux.nl/Books/books/www.leothreads.com/e-book/oreillybookself/tcpip/firewall/index.htm)

## Security Design Elements 

- The weakest link : security of system is as strong as its weakest point
- Choke points : structure the network as the only way to reach a certain area is through a `specific Access Point`
- Defense-in-depth: *multiple overlapping* security systems running on the same network (`nested security`):
  - add security redundancy + remove single point of failure
  - attacker has to find `multiple vulnerabilities` in different components
- [Universal participation](http://litux.nl/Books/books/www.leothreads.com/e-book/oreillybookself/tcpip/firewall/ch03_06.htm) : absence of active opposition to the security approach implemented in the network + presence of active participation from users
- diversity of defense : use different type of security mechanisms

> Routers are meant to `make the traffic flow`. However, we can introduce some `decisions, rules, permissions` before allowing a packet to flow between networks through `firewalls`

- Least privilege: giving the permissions to perform an action  `at most` and no extra rights
- [Fail-Safe Stance](https://docstore.mik.ua/orelly/networking_2ndEd/fire/ch03_05.htm) : if anything goes wrong, lets be sure that the system will `fail safe` : 
  - *The default deny stance* Specify only what you allow and prohibit everything else. 
  - *The default permit stance* Specify only what you prohibit and allow everything else.
   
## Types of Firewalls

[`Firewall`](https://en.wikipedia.org/wiki/Firewall_(computing)): device that beside acting as a router define rules for `implement a security policy`:
- regulate `allowed traffic` with firewalls by filtering : packets, source, destination, services, connections ...
- Monitor hosts and traffic for `bad behaviour` : [intrusion detection systems](https://en.wikipedia.org/wiki/Intrusion_detection_system)
- Protect traffic by `encryption` : VPN, SSL, TSL, HTTPS...
- Simplicity : Make it simple!!
  
### Types by Role in the network:
 
> different types on firewalls have different **Roles** base on the type of **traffic** they screen and **where** they are placed in the network

- Host based packet filter :
  - ROLE : single-host filtering of packets 
  - TRAFFIC : in\out a single host ONLY + work per-app (each application has its known policy that has to obey)
  - WHERE : in personal machine of network's hosts
- Screening Router ([ACL-based](http://www.di-srv.unisa.it/~ads/corso-security/www/CORSO-0203/Cisco/cisco827_htm/cisco827_acl_std.htm)) :
  - ROLE : all Network filtering of packets by site's security policy
  - TRAFFIC : all Network flow + ONLY packets not meant for him (FORWARD IpTables chain)
  - WHERE : edge Routers 
> [Network Access Control Lists](https://en.wikipedia.org/wiki/Access-control_list#Networking_ACLs) : 
> - List of rights\rules applied to interface,ports and IPaddr
> - `Stateless` : every packet is treated independently (*no knowledge - no memory*)
> - distinguish between incoming-outgoing traffic per interface\port number
- [Bastion Host](https://en.wikipedia.org/wiki/Bastion_host):  
  - ROLE : App. proxy Server + VPN Server + Honeypot ...
  - TRAFFIC : all Network flow 
  - WHERE : edge of Network + DMZ
    + `more regulating features than router`
> `Hardening` is the task of reducing or removing vulnerabilities in a computer system:
> - Shut down unused\dangerous services
> - Strict access and configurations to vital files
> - Remove unnecessary accounts and permissions

> `Dual-homed` : when we have 2 interfaces `physically dividing` the internal from the external network

## Demilitarized zone - DMZ

- `neutral zone` between private network and outside public network 
- `secure segregation` of private network from the one that hosts services for external users, visitors and company's partners
- `regulate access` to internal components of the IT system 

### DMZ cases

> implementation of **defense-in-Depth** approach to security
- DMZ as screened Host : 
  - Screening router $\rightarrow$ redirect all traffic to Bastion Host
  - Bastion Host $\rightarrow$ make decisions over traffic flow directed to the network
    - dual\single homed Host
- Screened Subnet :
  - External Router + Internal Router
  - Bastion Host 
  - ***split DMZ*** : `multiple nested layers` of DMZ with different services, permissions ...
- Segmented Network :
  - one Firewall segmenting network in more pieces
  - like start topology
  - **a lot of complexity to manage** : not easy
  
# Packet Filtering 
slide 21 packet filtering ::::


