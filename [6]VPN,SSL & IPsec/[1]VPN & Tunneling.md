# VPN Principles
>  A virtual network, built on top of an existing network infrastructure providing secure communication mechanism for data and other information transferred between two endpoints

#### Main Goals 
$\rightarrow$ **usability** (*If a solution is too difficult to use, it will not be used*)

$\rightarrow$ Confidentiality + integrity + Peer Authentication

$\rightarrow$ Replay Protection(*reuse packets*) + Access Control + Traffic Analysys Protection(*extrapolate info from encrypted traffic analysis*)

#### Usability Goals 

- Transparency(*invisible to users,sw and HW*)
- Flexibility(*used between users,app.hosts,sites*): every level of stack
- Simplicity(*it can be actually used*)

#### configurations Flexibility

- Host-to-site (*to join internal VPN*)
- Host-to-host (*2 machine's endpoints private connection*)
- site-to-site (*link 2 main edge-Routers as they are connected by a local cable*)

#### Where to perform encryption on Protocol stack?

|Layers|Confidentiality|Integrity|Authentication|
|--|--|--|--|
|Physical |on cable|on cable|no need|
|Data Link|on link|on link|x|
|Network|between hosts/sites|between hosts/sites|for hosts/site|
|Transport|between apps/hosts/sites|between apps/hosts/sites|for user/host/site|
|Application|between users/apps|between users/apps|for user|

|Layers|Replay Protection|Access Control|Traffic Analysis Protection|
|--|--|--|--|
|Physical |x|need physical access|on cable|
|Data Link|x|need physical access|on link|
|Network|between hosts/sites|to host/site|who generates info is exposed|
|Transport|between apps/hosts/sites|users/hosts/sites|protocol/host/site info exposed|
|Application|between apps|only data access secured|all but data exposed|

|Layers|Transparency|Flexibility|Simplicity|Protection Idea|
|--|--|--|--|--|
|Physical |full(*no changes on top*)|bad|excellent||
|Data Link|full|bad|excellent|protect a single link|
|Network|possible|need SW/HW mods|site-to-site good // host-to-site a lot of config|protect end-to-end systems|
|Transport|possible|need SW/HW mods|site-to-site + host-to-site good|protect end-to-end processes|
|Application|only user|need SW mods|Depends on the App|protection for a single Application|


> *When we can implement VPN?* It looks best to introduce security in the:
- App Layer (*S/MIME;PGP*)
- ***Transport Layer*** (*SSLv3/TLSv1;OpenVPN*)
- ***Network Layer*** (*IPSEC*)
- Data Link layer (*PPP;PPTP;L2TP;LTF*)

***
## VPN device placement

> *Where put VPN functionality inside network devices?*

#### VPN-enabled Firewall
![image](/images/fw.JPG)

● Advantages
  - No holes in FW between external VPN device and internal network
  - Traffic between device and internal network must go through FW
  - Simple network administration since only one “box” to administer

● Disadvantages
  - Limited to VPN functionality offered by FW vendor
  - FW directly accessible to external users via port **443**
    - TCP port 443 (standard) must be **open on external FW interface**, so clients can initiate connections
  - Adding VPN functionality to FW can introduce vulnerabilities

#### VPN on internal Network
![image](/images/fw2.PNG)

● Advantages
- Only single rule for single address to be added to FW
- No “holes” needed in FW between VPN device and internal network
- VPN traffic is behind FW, so protected from attacks by machines in DMZ

● Disadvantages
- VPN traffic passes through FW on tunnel, so it *is not analyzed*
- Unsolicited traffic can be sent into internal network from outside to internal VPN device
- Internal network **is compromised** if VPN device is compromised

TCP port 443 (standard) opened on FW for the address of the device
#### VPN in DMZ
![image](/images/fw3.PNG)

● Advantages
- Internal network *protected against compromised VPN* device
- Traffic between device and internal network must go through FW
- IDS in DMZ *can analyze traffic* destined for internal network

● Disadvantages
- Numerous ports open in FW between device and internal hosts
- **Decrypted traffic** from device to internal network must be sent through DMZ
- FW bypassed when user traffic is destined for hosts in DMZ

TCP port 443 (standard) opened on FW for the address of the device
#### VPN in DMZ Dual-interface
![image](/images/fw4.PNG)

● Clients connect to external device interface, internal traffic uses internal interface

● Advantages
- All advantages of placing VPN device DMZ
- *Unencrypted traffic* to internal hosts **is protected** from other hosts in DMZ
- Only FW interface connected to device’s internal interface needs to permit traffic from VPN device

● Disadvantages
- Numerous ports open in FW between device and internal hosts
- May introduce additional routing complexity
- FW bypassed if split tunneling is not used and user traffic is destined for hosts in DMZ

# SSL Tunneling 
> Operation of a network connection on top of another network connection
> - Tunneling offers the basic method for providing a VPN
> - Enables a [PDU](https://it.wikipedia.org/wiki/Protocol_Data_Unit) to be transported from one site to another *without its contents being processed* by hosts on the route

● Idea: *Encapsulate* the whole PDU in another PDU sent out on the network connecting the two sites
- Encapsulation takes place in edge router on src. site
- Decapsulation takes place in edge router on dst. site

● Note that the host-to-host communication does not need to use IP

#### Secure tunneling 
● Idea: *Encrypt* the PDU, *and then encapsulate* it in another PDU sent out on the network connecting the two sites
- Encryption can take place in edge router on src. site
- Decryption can take place in edge router on dst. site
  
● Note: dst. address in IP header is for dst. edge router

## Secure Socket Layer (SSL)
> SSL 3.0 has become TLS standard ([RFC 2246](https://datatracker.ietf.org/doc/html/rfc2246)) with small changes
> 
> [Transport Layer Security](https://it.wikipedia.org/wiki/Transport_Layer_Security)
- Applies security in the Transport layer
- If implemented *on boundary routers* (or proxies), can provide a tunnel between two sites – typically LANs
- Placed on top of TCP, so no need to change TCP/IP stack or OS
- Provides secure channel (byte stream)
  - Any TCP-based protocol
  - https:// URIs, port 443
  - NNTP, SIP, SMTP...
- Optional server authentication with public key certificates

> [To Protocol Overview](/[6]VPN,SSL%20&%20IPsec/[2]SSL%20protocol%20overview.md)

### HTTPS: HTTP on to of TLS
> TLS is used for exchange data using session key
![image](/images/https.PNG)

- host request Certificate of destination created by Certification Authority
- host verify signature and Authenticity of certificate + not expired 
  - Accepts correlation of Public key with destination site 
- encrypt Session/symmetric Key using this Public key 
  - TLS generate symmetric cryptography channel 
  - exchange data with session key created

## SSL VPN Architecture 
1. SSL Portal VPN, Allow remote users to:
  - Connect to VPN gateway from a Web browser
  - Access services from Web site provided on gateway
2. SSL Tunnel VPN, Allow remote users to:
  - Access network protected by VPN gateway from Web browser allowing active content
  - **More capabilities** than portal VPNs, as easier to provide **more services**

### SSL VPN functionalities

- Proxying: Intermediate device appears as true server to client. E.g. Web proxy
- Application Translation: Conversion of information from one protocol to another
  - e.g. Portal VPN offers translation for applications which are not Web-enabled, so users can use Web browser to access applications with no Web interface
- Network Extension: Provision of partial or complete network access to remote users, typically via Tunnel VPN
  - Two variants:
  - Full tunneling: All network traffic goes through tunnel
  - Split tunneling: Organisation’s traffic goes through tunnel, other traffic uses remote user’s default gateway

### SSL VPN Security Services

- **Authentication** Via strong authentication methods, such as two-factor authent., X.509 certificates, smartcards, security tokens etc.
- **Encryption and integrity protection**: Via the use of the SSL/TLS protocol
- **Access control**: May be per-user, per-group or per-resource
- **Endpoint security controls**: Validate the security compliance of clients attempting to use the VPN
- **Intrusion prevention**: Evaluates decrypted data for malicious attacks, malware etc.

> ***Crypto is insufficient for Web security***
> 
> Trust: what does the server really know about the client?
> - SSL provides a secure pipe. “Someone” is at the other end; you don’t know who!!
> - Usually there is no user authentication in SSL, but in the application layer!
> Use Client-Certificates for ensure other security properties as Authentication, Integrity, Non-Repudiation etc..