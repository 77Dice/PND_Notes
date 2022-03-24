# IPv6 vs. IPv4 Protocol overview

## IPv6 Packet

>([v6 Wiki](https://en.wikipedia.org/wiki/IPv6_packet)|[v4Wiki](https://en.wikipedia.org/wiki/IPv4)) IPv6 packet has Fixed size and Simpler header than IPv4

IPv6 has fized size of `40 bytes` or *320 bits*
- 64 bits of :
  - (4bit) Version 6 or 4 
  - (8bit) Traffic class uses same services technique as v4 ([link](https://www.geeksforgeeks.org/internet-protocol-version-6-ipv6-header/))
  - (20bit) Flow label is new field and is used for identify packets in a `common stream`
    - Traffic from source to destination share a `common flow label`  (different TCP sessions)
  - (16bit) Payload Length defines size of `Extension Headers + data` without main v6 Header size
  - Next Header
  - Hop limit
- 128 bits of Source/Destination Address

IPv4 only fields:
- (4bit)Internet Header Length(IHL) 32bit words not used in v6 because it has fixed header 
- (8bit)Type of service as v6 Traffic class 
- Total Length not used because v6 has fixed size
- 

## Fragmentation ... v4 vs v6



- headers
- fragmentation
- extension header