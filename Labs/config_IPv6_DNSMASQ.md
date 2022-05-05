> [Guide](https://www.youtube.com/watch?v=zGnpZnxWQ5c)

we receive /56 network
we split in half :
- half for main firewall
- half for internal firewall
```
2001 : 470 : b5d8 : 15///00::(/56)
16 : 16 : 16 : 8/// 8: ...  (/56)
first 56 bytes of prefix
last "15" stands for ACME-21 in exadecimal --> 15

```
first "00" are for subnetting (we divide it in 2 parts and then in 4 parts ) one for each subnet 
```bash
#(1500 / 1540)MAIN + (1580 / 15B0)INternal
```
we will have networks of /64 but in fact they change only according to /60 (1500,1501,...150F + 1582,1586,158A,...158F) 
            
    so we can always remember where they come from if 150x EXTERNAL or 158x INTERNAL
- DMZ (100.100.6.0/24) will be (2001:470:b5d8:1506::/64) with 06 as third octect of IPv4 net address
- EXT CL (100.100.4.0/24) will be (2001:470:b5d8:1504::/64) 
- INTERNAL will be 150F because we cannot use 15FE (it belongs to internal router)
- SERVER -> 1581
- INT CL -> 1582
* * *

fd00:: addresses??

[Unique_local_addr](https://en.wikipedia.org/wiki/Unique_local_address)

add to IPv6 addressing

* * *
1. ask for DELEGATION via DHCPv6 from ISP
2. for every interface : Track Interface option with related subnet
   - DMZ 0x06 
     - we will have 2001:470:b5d8:15_06:EUI64/64 as main-router address
   - EXT 0x04
3. then delegate to Internal /60 networks (:1580::)
   - add manual adjustment of DHCPv6 to send RA to internal ROUTER
   - Services -> RA section
     - select MANAGED RA (m+o flags)
   - Services -> DHCPv6
     - ::80 to ::80 with /60 
     - ::2 to ::2 send exactly that address /128 to the internal Router
4. do the same on INternal FW and over other interfaces
   - assign 0x1 0x2 only one byte. it's only /60
5. ... end

* * *
# DNS MASQ





