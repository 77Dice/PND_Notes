# IPsec
> [RFC_4301](https://datatracker.ietf.org/doc/html/rfc4301) : Security Architecture for the Internet Protocol (ipsec)
> 
> [ref.](http://www.tcpipguide.com/free/t_IPSecurityIPSecProtocols.htm)

![image](/images/ipsec.PNG)
Network Layer protocol suite for ***providing security over IP***
- part of IPv6; an add-on for IPv4
- Basic functions are provided by sub-protocols

|Concepts|Fundamental Sub-Protocols|Protocol Modes|Key Management Protocols|
|--|--|--|--|
|Security Association (SA) and Security Association Database (SAD)|Authentication Header (AH)|Transport Mode|ISAKMP|
|Security Policy (SP) and Security Policy Database (SPD)|Encapsulation Security Payload (ESP)|Tunnel Mode|IKE, IKEv2|

## IPsec General Overview
GOAL $\rightarrowtail$ agree on how to make communication secure

![image](/images/ipsec3.PNG)

1. Authentication, key Exchange and negotiation of crypto algorithms
     - Manual
     - Automated: ISAKMP, Internet Key exchange (IKE) v2
2. Set up key and crypto-algorithms
3. Use of the secure channel with:
     - Data integrity via (AH) or (ESP)
     - Confidentiality using (ESP)

## IPsec services (sub Protocols)
![image](/images/ipsec2.PNG)
- Authentication Header (AH): Support for data integrity and authentication of IP packets
- Encapsulated Security Payload (ESP): Support for encryption and (optionally) authentication
- Internet Key Exchange (IKE): Support for key management etc.


## IPsec [Security policies](https://it.wikipedia.org/wiki/IPsec#Security_Association_e_Security_Policy)
> def. *Specifies **which security services should be provided to** IP packets and their details;*
>
> *determines **whether a packet is subject to** IPsec processing and governs the processing details*
- The SPD policy entry includes SAs for traffic that is subject to IPsec processing
- one SP affects only a specific IP stream
- For each stream, it includes:
  - The security protocol (AH / ESP)
  - The protocol mode (Transport / Tunnel)
  - Other parameters, like policy lifetime, port number for specific applications, etc.
  - **The actions**

|Discard|Bypass (send in clear)|Secure|
|--|--|--|
|reject to send/receive the packet|do not handle with IPsec|handle with IPsec|
> - the policy is in the form:
>   - ***protocol/mode/src-dst/level*** 
- where:

|Protocol|Mode|Src-dst|Level|
|--|--|--|--|
|as,esp |tunnel |endpoints of the tunnel|default,use,require,unique|
|or ipcomp(payload compression)|or transport|(if needed)|level of the SA,when a keying daemon is used|
- Security Policies are stored in the [***Security Policy Database***](https://datatracker.ietf.org/doc/html/rfc4301#section-4.4.1) (SPD)
- **The matching of a packet** to a policy entry is by means of a selector
- The possible fields for constructing the selector can be:
  - src/dest addr, Transport Layer Protocol, src/dst Protocol Ports, User ID or System name etc.

### SP example
```bash
#ip from [port] dest [port]
100.90.0.100[any] 100.60.0.100[any]
...
# use esp + transport mode and it's required --> if no SA then don't send the packet
esp/trasport//require
```
![image](/images/SP.PNG)


## IPsec Security Associations
> as **an IPsec connection**: whenever we need to establish a secure channel we need to decide **the details of communication**;
> 
> these are **called Security Associations** (crypto/auth algorithms, modes of operation, key length, type of traffic etc.)

> Def. *is a simplex channel that describes the way how packets need to be processed*

- Both sides must agree on the SA for secure communications to work
- *unidirectional*: For a two-way communication, two SAs must be defined
  - Bidirectional communication **requires two security associations**
- SA parameters must be negotiated (using IKE) between sender and receiver before secure communication can start
- Each SA is associated with either AH or ESP (not both)
- Each SA is identified by:
  - *Security Parameters Index (SPI)*: 32-bit integer chosen by sender
    - **UNIQUE Identifier** for quick reference on how to protect that channel
    - Enables receiving system to select the required SA
  - *Destination/Src Address*: Only unicast IP addresses allowed!
  - *Security Protocol Identifier*: AH or ESP
  - *IPsec protocol mode*: tunnel/transport
  - *Prot. algorithms, modes, IVs, keys*
  - *SA lifetime*
  - *current sequence number counter*: against replay attacks
  - [RFC_4301](https://datatracker.ietf.org/doc/html/rfc4301#section-4.4.2.1) $\rightarrowtail$ data items that MUST be in a SAD
- Security Associations are stored in the [***Security Association Database***](https://what-when-how.com/ipv6-advanced-protocols-implementation/security-association-database-ipv6-and-ip-security/) (SAD)
> you need one SA **for every single host you are communicating**; one for every channel established

### SA example
```bash
#src/dest addr
100.60.0.100 100.90.0.100
# mode
esp mode=trasport spi=...
# encry mode and key
E: aes-cbc [symmetric key]
...
# opposite direction info
...
```
![image](/images/SA.PNG)


## Processing of IPsec traffic

### outgoing 
Alice wants to send data to Bob, then IP layer of Alice has to:
1. Determine if and how the outgoing packet needs to be secured
   -  Perform a *lookup in the SPD* based on traffic selectors
   -  If the policy specifies *discard* --> drop the packet
   -  If the policy *does not need* to be secured --> send it
2. Determines which SA should be applied to the packet
   - If no SA is established perform IKE
   - There may be more than one SA matching the packet (e.g. one for AH, one for ESP)
3. Look up the determined or freshly created SA in the SAD
4. Perform the security transforms, specified in the SA
   - This results in the construction of an AH or ESP header
   - Possibly a new (outer) IP header will be created (tunnel mode)
5. Send the resulting packet

### ingoging 
Alice receives data from Bob, then the IP layer of Alice has to:

- If packet contains an IPSec header
  - Perform a lookup in the SPD
  - if Alice is supposed to process the packet --> Retrieve the respective policy
- If Alice is supposed to process the packet
  - Extract the SPI from the IPSec header, look up the SA in the SAD and perform the appropriate processing
  - If there’s no SA referenced by the SPI ⇒ Drop the packet
- Determine if and how the packet should have been protected
  - Perform a lookup in the SPD, evaluating the inner IP header in case of tunneled packets
  - If the respective policy specifies discard  ⇒ Drop the packet
  - If the protection of the packet did not match the policy  ⇒ Drop the packet
- Deliver to the appropriate protocol entity (e.g. network / transport layer)

## IPsec Modes

- Transport Mode
  - Provides protection *for a Transport-layer packet* embedded as payload in an IP packet
- Tunnel Mode
  - Provides protection *for an IP packet* embedded as payload in an IP packet

![image](/images/modes.PNG)
> we can merge these 2 modes with services/sub-protocols of IPsec

## Authentication Header (AH)

IP header fields contains:
- Next Header: Type of following header field
- Payload Length: (Length - 2), in 32-bit words, of AH
- SPI: Identifies SA in use
- Sequence Number: Monotonically increasing packet counter value
- **Authentication Data (AD)**: (variable length) HMAC based on MD5 or SHA-1 cryptographic hashing algorithm, or AES-CBC, evaluated over:
  - Immutable or predictable IP header fields. (Other fields assumed zero when MAC is calculated.)
  - Rest of AH header apart from AD field
  - All embedded payload (from T-layer or embedded IP packet), assumed immutable

### Authentication in IPv4/v6
- AH header inserted after the outermost IP header
  - depending on whether Transport or Tunnel mode is used
  ### ***REMEMBER!!***
- Do not forget that integrity check (and thus authentication) **does not cover any mutable**, unpredictable **header fields** (TTL, checksum etc.)
  - Such fields are assumed to be zero for MAC computation
> IPv4 authenticated packet
> ![image](/images/ipv4_auth.PNG)

> IPv6 authenticated packet
> AH is an extension header **by design**
>![image](/images/ipv6_auth.PNG)

## Encapsulated Security Payload IPv4/v6 (ESP)
- ESP header inserted after the outermost IP header
  - depending on whether Transport or Tunnel mode is used:
  - **Padding** is added to end of Transport-layer payload to give (a certain amount) of **traffic analysis protection**
  - ESP trailer and (optional) ESP authentication field added after the end of the padded T-layer payload
- integrity check (and thus authentication) does **not cover any mutable**, unpredictable **header fields**

> IPv4 ESP packet
> ![image](/images/esp.PNG)

> IPv6 ESP packet
> ![image](/images/esp_v6.PNG)

## Encryption + Authentication
> How achieve that with IPsec?

1. ESP with Authentication $\rightarrow$ (apply ESP to data, then add AH field) Two subcases:
   1. Transport mode $\rightarrowtail$ E+A apply to IP payload, but IP header not protected
   2. Tunnel mode $\rightarrowtail$ E+A apply to entire inner packet
2. Transport Adjacency $\rightarrow$ Use bundled SAs, first ESP, then AH
3. Encryption covers original IP payload
   - Authentication covers ESP + original IP header, including source and destination IP addresses
4. Transport-Tunnel bundle $\rightarrow$ Used to achieve **authentication before encryption**, for example via inner AH  transport SA and outer ESP tunnel SA
5. Authentication covers IP payload + IP immutable header
   - Encryption is applied to entire authenticated inner packet
>***remember*** $\rightarrowtail$ one SA is bounded with AH or ESP, you need 4 SA for bidirectional communication using both sub-protocols

> - AH provides data integrity and replay protection
> - ESP provides data integrity, replay protection and encryption
## Internet Key Exchange protocol v2 
> A standardized authentication & key management protocol [RFC5996](https://datatracker.ietf.org/doc/html/rfc5996)
> - dynamically establish SAs between two endpoints
> - IKEv2 provides unified authentication and key establishment
>   - Support for DoS mitigation through use of cookies
>   - Mutual authentication of the Initiator and Responder
>   - Negotiation of cryptographic suites
>   - latency is 2 round trips (i.e., 4 messages) in
the common case
> - Tries to achieve trade-off between features, complexity and security under realistic threat model
> - Runs on UDP ports { 500, 4500 }

### IKEv2 phases
IKEv2 communication consists of message pairs; It run starts with two exchanges 

one pair(req/response) is called an exchange 

1. *initialization & negotiation (Phase 1) IKE_SA_INIT* 
   - *Negotiates security parameters* for a security association (IKE_SA)
     - encryption alg, Integr. protection alg, DH group(p,g) PR function etc...
   - Sends nonces and Diffie-Hellman values (agree on shared key)
   - ***IKE_SA*** is a set of security associations 
     - used to encrypt and integrity protect all the remaining IKEv2 exchanges     
2. *authentication (Phase 2) IKE_AUTH*
   - Authenticates the previous messages
     - by bublic key signatures or long-term pre-shared key
   - Transmits identities
   - Proves knowledge of corresponding identity secrets
   - Creates first ***CHILD_SA*** 
     - *derived from SA : parameters you want to use in the channel*
     - A CHILD_SA is a set of SAs, used to protect IP traffic with AH/ESP protocol
     - The term CHILD_SA is synonymous to the common definition of an SA for IPSec AH and ESP
3. ### IKE outcome 
  - ![image](/images/ike.PNG)

# IPsec Overview
![image](/images/ipsecBIG.PNG)
*"from user Space a packet need to be send to bob"*
1. The administrator sets a policy in SPD
     - *"if you want to send a packet to bob you need to use this protection --> IPsec with AH, Tunnel mode and ..."*
2. The IPSec processing module refers to the SPD to decide on applying IPSec on packet
3. If IPSec is required, then the IPSec module **looks for the IPSec SA** in the SAD
   - *looks for the SA related to the SP required for communication with Bob*
4. If there is no SA yet, the IPSec module sends a request to the IKE process to create an SA
5. The IKE process ***negotiates*** keys and crypto algorithms with the peer host using the IKE/IKEv2 protocol
6. The IKE process writes the key and all required parameters into the SAD
7. The IPSec module can now send a packet with applied IPSec

# IPsec vs TLS
- TLS much *more flexible* because is in the upper levels
- TLS also provides application *end-to-end security*, best for web applications → HTTPS 
- IPsec hast to run ***in kernel space***
- IPsec much *more complex* and complicated to manage with

![image](/images/compare.PNG)
***
Data origin authentication
- It is not possible to spoof source / destination addresses without the receiver being able to detect this
- It is not possible to replay a recorded IP packet without the  receiver being able to detect this

Connectionless Data Integrity
- The receiver is able to detect any modification of IP datagrams in transit 
 
Confidentiality
- It is not possible to eavesdrop on the content of IP datagrams
- Limited traffic flow confidentiality

Security Policies
- All involved nodes can determine the required protection for a packet
- Intermediate nodes and the receiver will drop packets not meeting these requirements

# IPsec Standardization documents
> [IPsec_RFC_reference](https://datatracker.ietf.org/wg/ipsec/documents/)

![image](/images/protoIPsec.PNG)