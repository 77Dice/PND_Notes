
# Network Eavesdropping/Sniffing 

> GOAL : *capture packets transmitted by other's nodes through the network and analyze it in search of sensitive information*([Sniffing](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing.htm)) 
> - all clear data *exchanged by unsafe protocols* : **without encryption**
>   - *HTTP, SMTP, POP, FTP, IMAP, DNS...*

> Tools $\rightarrowtail$ [Network Sniffers](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing_tools.htm) + protocol decoders or stream reassembling

## What it requires?
+ Passive or active mode
- work in passive/active mode ,++ promisquous mode  :: 

mode link :: [relative link to promisc mode](/Labs/%5B1%5DNetworking%20101%2Bscript.md#Network%5FTraffic%5FMonitoring)
- use tools ... list 
- capture 

-  how do it ?
   -  NIC in promisquous mode 
   -  sniffer on the hub/same network/ wire 
      -  non switched lan
      -  switched lans by flooding (**breaks switch segmentation**)
      -  by **arp spoof** attack and redirect traffic (men in the middle like)
      - wireless lan (only if **no or weak encryption is used**)
      - 

- bridges :: what they are?
- switches :: //?
- CAM //?


- how break the switch segmentation mechanism??
  - CAM overflow ..



***

# ARP spoofing/poisoning

how it works + ARP table
- responses 
- security of ARP
- type of attacks :
  - DOS
  - MITM attack


# IPv6 Neighbor Discovery --- ARP poisoning for IPv4
IPv6 Neighbor Discovery threats

- how addr resolution works in IPv6?

- known threats  RFC 3756

● IPv6 Rogue RA (or RA spoofing)
● Rogue DHCP



FORSE POSSO METTERE TUTTO DENTRO I LAB...

 
 ++ LAB 3 Activity