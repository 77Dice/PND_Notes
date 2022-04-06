1. Multicast x all devices FF02::1 + only `advertisement` will have the info of the prefix; and only router distribute it
2. checksum is implemented by upper layers TCP + mandatory UDP so it has been removed.
3. also RS is related to NDP and is part of the protocol(one of 5 types). only echo request is out of context
4. IPv6 header ir FIXED, therefore it has been removed
5. easy as that : MULTICAST + LL ==> scope 2 ; C D are not ll
6. easy as that : send always MULTICAST LL and REPLY with UNICAST. NO BROADCAST & NO GUA
7. tricky, just focus on what is wrong and what is right affermation. then take false ones
8. ARP == NEIGHBOUR SOL/ADV
9.   .
10.  only B is the right answer. RS is not part of NDP
11.  FF + well-known(0) + link local(2) + all devices group (::1)
12.  multiple A + D
