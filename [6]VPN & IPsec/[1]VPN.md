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
- key exchange
- heartbeat attack