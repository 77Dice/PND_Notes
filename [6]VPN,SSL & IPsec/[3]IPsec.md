# IPsec
![image](/images/ipsec.PNG)
Network Layer protocol suite for providing security over IP
- a part of IPv6; an add-on for IPv4
- Basic functions are provided by sub-protocols

### IPsec services
![image](/images/ipsec2.PNG)
- Authentication Header (AH): Support for data integrity and authentication of IP packets
- Encapsulated Security Payload (ESP): Support for encryption and (optionally) authentication
- Internet Key Exchange (IKE): Support for key management etc.

### IPsec Security Associations
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
  - *Destination Address*: Only unicast IP addresses allowed!
  - *Security Protocol Identifier*: AH or ESP
- Security Associations are stored in the [Security Association Database](/Labs/TODO!%5B6%5DIPSec.md/###(SAD)) (SAD)
> you need one SA **for every single host you are communicating**; one for every channel established

### IPsec Modes

- Transport Mode
  - Provides protection *for a Transport-layer packet* embedded as payload in an IP packet
- Tunnel Mode
  - Provides protection *for an IP packet* embedded as payload in an IP packet

![image](/images/modes.PNG)
> we can merge these 2 modes with services/sub-protocols of IPsec

## Authentication Header

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
- Do not forget that integrity check (and thus authentication) **does not cover any mutable**, unpredictable **header fields** (TTL, checksum etc.)
> IPv4 authenticated packet
> ![image](/images/ipv4_auth.PNG)

> IPv6 authenticated packet
> AH is an extension header **by design**
>![image](/images/ipv6_auth.PNG)

## Encapsulated Security Payload IPv4/v6
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

# IPsec vs TLS
- TLS much *more flexible* because is in the upper levels
- TLS also provides application *end-to-end security*, best for web applications → HTTPS 
- IPsec hast to run *in kernel space*
- IPsec much *more complex* and complicated to manage with

![image](/images/compare.PNG)