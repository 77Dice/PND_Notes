# Simple Tunneling
> [MAN page](https://man7.org/linux/man-pages/man8/ip-tunnel.8.html) | ip-tunnel is part of iproute2 project 

IDEA $\rightarrowtail$ tun/tap drive to create a Linux virtual interface **that encapsulates network traffic**
- tunnel type is based on **Internal and external(encapsulating) traffic** type 
  - ex. (SIT tunnel $\rightarrow$ interconnect isolated IPv6 networks, located in global IPv4 internet )
  - exist a tunnel for every case: [possible Tunnels guide](https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels#)
- tun encapsulate IP layer (only one routable)
- tap encapsulate Ethernet layer

![image](/images/tun1.PNG)
Any application can use that interface without any need to change its code 

### EX1 
> GOAL: setup IPv4 tunnel between 2 LANs 
```bash
# generate tunnel, use addresses of interfaces exposed on WAN 
ip tunnel add tun0 mode ipip remote <ipaddrR> local <ipaddrL>
# activate tunnel
ip addr add 10.0.0.1|2/30 dev tun0
ip link set tun0 up
# add route to remote SUB-network via remote endpoint of virtual interface
ip route add <SUBremoteNET> via 10.0.0.2
```
- tunnel type is **IPv4 over IPv4** (ipip)
- at this point we can eavesdrop the traffic with wireshark
  - every packet of every protocol will be encapsulated inside an IPv4 header 
  - also ICMP packets or others protocols packets 
  - bigger packets will be fragmented
- tunnel encapsulate data **but do not encrypt them**
- OpenVPN encrypt them 

# OpenVPN
> Open-source software to realize VPN, namely ***encrypted tunnels***
> - OpenSSL based (crypto-auth-integr library)
> - UDP with one single port 
>   - reliability is already achieved by protocols forwarded inside the tunnel
>   - [multiplexing](https://build.openvpn.net/doxygen/group__internal__multiplexer.html) possibility
> - Multiple modes
>   - Static: symmetric shared key
>   - Dynamic: Public Key Infrastructure
> 
> ![image](/images/tun2.PNG)
> crypto depends on SSL 
## Static mode
The endpoints share a key generated with openvpn command
- Very easy to configure
- No CA or certificates
- requires pre-exchange of the keys ([using scp](https://man7.org/linux/man-pages/man1/scp.1.html))
  - The key never changes: no forward secrecy
- Uses 4 independent keys to reduce the risks of Replay and DoS attacks
  - K_AB / K_BA (one way encryption)
  - HMAC_AB / HMAC_BA (one way authentication)

## Dynamic mode

### EX2 
> GOAL: setup tunnel in privileged mode and use OpenVPN for encryption (Static & Dynamic mode)
```bash
## static mode
# key generation to exchange using scp
opnevpn --genkey --secret secret.key

file.conf???




```
follow 
