# Preliminars + script

- enable IPv6 on kathara settings
- start lab with privileges or by scripts:
```

```

> kathara need start with privileges + IPv6 enabled + 

# reference links


[IPv6 sysctl-flags](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)

[radvd](https://manpages.debian.org/testing/radvd/radvd.conf.5.en.html)
[radvd2](https://www.linuxtopia.org/online_books/network_administration_guides/Linux+IPv6-HOWTO/hints-daemons-radvd.html)
[dhcpv6BIBLE](https://klub.com.pl/dhcpv6/doc/dibbler-user.pdf)
[DNSMASQ](https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html#index)

## use ip -6 / inet6 commands how i change commands ???


| IPv6 Only | --|
| --| --| 
| route -6 | show IPv6 routing table |   
| traceroute\ping a.b.c.d  | test if reachable  |

## scope links for L-L

## ROUTE -6 ex1

>> route -6 for showing routing and default route on IPv6 only addresses (GUA+ LL)

>> I cannot configure any route on R1 ?? why??

## how ping ipv6??

> ping -6 fe80::10x -I ethy   # works for GUA

> ping -6 fe80::10x%ethy # ONLY ONE THAT works for ll


# SLAAC + SYSCTL flags

