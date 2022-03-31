# Connection Script

works on: lab2/ex1

> how connect `host machine` to `VM` (guest machine)?

> after starting the lab we need to link one collision domain(local net) to a `virtual interface` ($veth_x\ veth_y$)

> we need to find the `docker image` related to the `collision domain` we want to connect : there exists `one for each network` with the same name as defined in the `.lab file`
```bash
sudo ip link del veth1 type veth
sudo ip link add veth1 type veth
sudo ip addr flush veth0
sudo ip addr add [addr/x] dev veth0

# find docker image of local network
sudo docker network list | grep kathara_[user]-xxxx_[lan]
                         | grep kathara_xxx
#bridge = xxx

sudo ip link set veth1 master kt-xxxx                        

sudo ip link set veth0 up
sudo ip link set veth1 up

ip addr show dev veth1
ip addr show dev veth1
-----------------------------
# on host machine ---listening on veth1
~$ tcpdump -ni veth1  

# host already has IPv6 scope address (by default...)
~$ ping fe80::101%veth0 # (only local lan)

# ---speaking through veth0
~$ sudo ip addr add [IPv6Addr/64] dev veth0
ping -I veth0 2001:db8:cafe:2::10x  # (all lab is reachable)

it works...