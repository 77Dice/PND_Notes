# Network Traffic Regulation

> [o'reilly_Building_Internet_Firewalls](http://litux.nl/Books/books/www.leothreads.com/e-book/oreillybookself/tcpip/firewall/index.htm)

## Security Design Elements 

- weakest link : security of systems is as strong as its weakest point
- choke point : structure the network as the only way to reach a specific area is through `specific Access point`
- defense in depth: have more than one security protection running on the same network (`nested security`)
- [Universal participation](http://litux.nl/Books/books/www.leothreads.com/e-book/oreillybookself/tcpip/firewall/ch03_06.htm) : absence of active opposition to the security approach implemented in the network + presence of active participation from users
- diversity of defence : use different type of security mechanisms
> Routers are meant to `make the traffic flow`. However, we can introduce some `decisions, rules, permissions` before allowing a packet to flow between networks through `firewalls`

- Least privilege: give at most permission to perform an action and no extra rights
- fail/safe stance : if anything go wrong, lets be sure that we end in a fail-safe state.... 

[`Firewall`](https://en.wikipedia.org/wiki/Firewall_(computing)): device that beside acting as a router define rules for `implement a security policy`:
- regulate `allowed traffic` with firewalls by filtering : packets, source, destination, services, connections ...
- Monitor hosts and traffic for `bad behaviour` : [intrusion detection systems](https://en.wikipedia.org/wiki/Intrusion_detection_system)
- Protect traffic by `encryption` : VPN, SSL, TSL, HTTPS...
- simplicity : Make it simple!!




Host based packet filters : on hosts 

Screening routers : 

NA control lists:


types of architectures (way to manage security of network)

think about flow of traffic in the interface and not the network
