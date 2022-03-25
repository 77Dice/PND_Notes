# IPv6 vs. IPv4 Protocol overview

## IPv6 Packet

>([v6 Wiki](https://en.wikipedia.org/wiki/IPv6_packet)|[v4Wiki](https://en.wikipedia.org/wiki/IPv4)) IPv6 packet has Fixed size and Simpler header than IPv4

IPv6 has fized size of `40 bytes` or *320 bits*
- 64 bits of :
  - (4bit) Version 6 or 4 
  - (8bit) Traffic Class uses same services technique as v4 ([link](https://www.geeksforgeeks.org/internet-protocol-version-6-ipv6-header/))
  - (20bit) Flow label is new field and is used for identify packets in a `common stream`
    - Traffic from source to destination share a `common flow label`  (different TCP sessions)
  - (16bit) Payload Length defines size of `Extension Headers + data` without main v6 Header size
  - (8bit) Next Header indicates types of header following IPv6 header
    - The Presence of an `Extension Header`
    - ([Next Header - list](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers)) 6=TCP | 17=UDP | 58=ICMPv6 | 88=EIGRP | 89=OSPF 
  - (8bit) Hop limit set by source, every router in path decrement by 1
    - `Drop` packet when ==0
- 128 bits of Source/Destination Address
  

some IPv4 fields:
- (4bit) Internet Header Length(IHL) 32bit words not used in v6 because it has fixed header 
- (8bit) Type of service as v6 Traffic class 
- (16bit) Total Length not used because v6 has fixed size
- (32bit) Fragmentation fields
- (8bit) Time-to-Live as *Hop limit* field 
- (8bit) Protocol as IPv6 *Next Header* field
- (16bit) header Checksum 
  - UDP checksum is optional in IPv4

> in IPv6 UDP checksum is mandatory and exists upper layers checksum (UDP,TCP) therefore it's not used in IPv6 anymore

  - (32bit) Option & padding to make sure v4 option fall on a 32-bit boundary

> IPv4 Options are handled using IPv6 Extension headers 

## IPv6 Extension Header

> ([link](https://www.cisco.com/en/US/technologies/tk648/tk872/technologies_white_paper0900aecd8054d37d.html)) They provide flexibility and features `without need of redisign` the entire protocol packet and allow IPv6 main header to have fixed size for `more efficient processing`

- Next Header field identifies either:
  - the protocol carried in the data portion of the packet
  - the presence of an extension header (optional)

### Extension Header Properties:

- `Flexible` (normally there are no EHs in IPv6 packets)
  - EHs are optional, providing a powerful and flexible mechanism for IPv6
  - In the Basic IPv6 header, the EHs and the upper layer header (if used),are linked using the Next Header field
    - This is called the `IPv6 Header Chain`
- `Fixed` (Types and order)
  - The number of Extension Header types is `fixed and standardised`

| Decimal val | EH Name     | EH Description |
| ----------- | ----------- |    ----------- |
|  0   | Hop-by-Hop Options     | info examined by every router along the path |
| 43   | Routing    | def. destination path |
|  44   | Fragment | end-to-end fragmentation |
|  51   | Autentication Header(AH)       | Authentication + Integrity |
| 50   | Encapsulating Security Payload(ESP)     | Authentication + Integrity + Encryption |
| 60   | Destination  Options   | info examined ONLY by destination node(s)  |

- `Processed only at endpoints` (Except Hop-by-Hop and Routing)
  - Packet processing complexity moved from the core to the edge of the Internet for `improved IPv6 performances`

==> As opposed to IPv4 Option(Processed by `every router`) that `slow down` packets 
  

## IPv6 Packets Fragmentation

- ([Benefits](https://stackoverflow.com/questions/6254973/what-are-the-benefits-of-removing-fragmentation-from-ipv6)) IPv6 intermediate devices does `not perform fragmentation` 
  1. Source send out IPv6 packet using `MTU of the interface`
  2. If segment of network has smaller MTU:
     1. sent back `ICMPv6 - Pck too big message` with right MTU to use 
     2. Source `adjust IPv6 packet size` for smaller segment
  3. Destination has no need to reassemble fragments
- ([Path MTU Discovery](https://en.wikipedia.org/wiki/Path_MTU_Discovery)) protocol discovers `Maximum Transmission Unit` size of the network 
  - used when links are greater than minimum MTU: *1280 bytes*
- IPv6 requires that every link to have:
  - Minimum MTU of *1280 bytes*; recommended *1500 bytes*

=> any type of fragmentation in IPv6 is handled `by end-nodes only` using extension headers ([link](https://www.geeksforgeeks.org/ipv6-fragmentation-header/))

## IPv4 Packets Fragmentation

> (16bit)identification + (4bit)Flags + (12bit)Fragments Offest  are IPv4 fields used for fragmentation reassembly

- When segment of the network has smaller MTU local router just fragment IPv4 packet
- Destination host will reassemble fragments
- IPv4 requires that every link to have:
  - Minimum MTU of *68 bytes*
  - Ability to receive packet of *576 bytes* either in one piece or fragmented
