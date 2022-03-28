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