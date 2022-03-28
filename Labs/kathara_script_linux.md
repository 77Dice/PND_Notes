LAB 1 / ex4

// errore nell'iniz del server ???? // 




# Connection Script

using lab2/ex1

> how connect `host machine` to `VM`(guest machine)?

> after starting the lab we need to link one colision domain(local net) to a `virtual interface` ($veth_x\ veth_y$)

# create our endpoint (host side)

```bash
sudo ip link del vethx type veth  #remove past eth info
sudo ip link add vethx type veth
sudo ip addr flush vethy    # create host side interface
sudo ip addr add 192.168.199.1/24 dev vethy 
```

# script analysis
```bash
#some bash
```


# find link to docketr image

> we need to find the image of docker related to the `colision domain` we want to connect : there exists one for each local network with the `same name` as the one `in the .lab file`
```
> ho dubbi su cosa davvero funziona...
1. vado diretto sullo script e vedo
2. slide 04 #40
3. appunti latex
bridge =>>  
# we need to find Network ID from:
docker network list   || >>brctl show | grep kt- ??? quale dei due funziona??
# then the name of bridge will be shown in :
ip l 
``kt-......``
```

# set VM side vethx
```
...
```
all elements not related to LABS 




# script 

```bash
sudo ip link del veth1 type veth
sudo ip link add veth1 type veth
sudo ip addr flush veth0
sudo ip addr add [addr/x] dev veth0

# find docker image of local network
sudo docker network list | grep kathara_[user]-xxxx_[lan]
                        grep kathara_xxx
#bridge = xxx

sudo ip link set veth1 master kt-xxxx                        

sudo ip link set veth0 up
sudo ip link set veth1 up

ip addr show dev veth1
ip addr show dev veth1

tcpdump -ni veth1 # on host machine  
# ---listen on veth1

# he already has IPv6 scope address (by default...)
ping fe80::101%veth0 # on host machine (only local lan)

sudo ip addr add [IPv6Addr/64] dev veth0
ping -I veth0 2001:db8:cafe:2::10x  # on host machine (all lab is  reachable)
# ---speak on veth0
it works...

