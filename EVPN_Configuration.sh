C1
net add loopback lo ip address 10.0.0.1/32
net add interface swp1-3
net add bgp autonomous-system 65000
net add bgp router-id 10.0.0.1
net add bgp neighbor LEAF peer-group
net add bgp neighbor LEAF remote-as external
net add bgp neighbor LEAF capability extended-nexthop
net add bgp neighbor swp1-3 interface peer-group LEAF
net add bgp ipv4 unicast network 10.0.0.1/32
net add interface swp5
net add bgp neighbor swp5 interface peer-group LEAF

net add bgp l2vpn evpn advertise-all-vni
net add bgp l2vpn evpn neighbor LEAF activate

C2
net add loopback lo ip address 10.0.0.2/32
net add interface swp1-3
net add bgp autonomous-system 65000
net add bgp router-id 10.0.0.2
net add bgp neighbor LEAF peer-group
net add bgp neighbor LEAF remote-as external
net add bgp neighbor LEAF capability extended-nexthop
net add bgp neighbor swp1-3 interface peer-group LEAF
net add bgp ipv4 unicast network 10.0.0.2/32
net add interface swp5
net add bgp neighbor swp5 interface peer-group LEAF

net add bgp l2vpn evpn advertise-all-vni
net add bgp l2vpn evpn neighbor LEAF activate

C3
net add loopback lo ip address 10.0.0.3/32
net add interface swp1-2
net del interface swp3 ip address 100.64.1.1/24
net add bgp autonomous-system 65003
net add bgp router-id 10.0.0.3
net add bgp neighbor SPINE peer-group
net add bgp neighbor swp1-2 interface peer-group SPINE
net add bgp ipv4 unicast network 10.0.0.3/32
net del bgp ipv4 unicast network 100.64.1.0/24 
net add bgp neighbor SPINE capability extended-nexthop

net add interface swp4
net add bridge bridge
net add bridge bridge ports swp4

net add vxlan RED vxlan id 10010
net add vxlan RED bridge access 10
net add vxlan RED vxlan local-tunnelip 10.0.0.3

net add vxlan BLUE vxlan id 10020
net add vxlan BLUE bridge access 20
net add vxlan BLUE vxlan local-tunnelip 10.0.0.3

net add vxlan GREEN vxlan id 10030
net add vxlan GREEN bridge access 30
net add vxlan GREEN vxlan local-tunnelip 10.0.0.3

net add bgp l2vpn evpn advertise-all-vni
net add bgp l2vpn evpn neighbor SPINE activate

C4
net add loopback lo ip address 10.0.0.4/32
net add interface swp1-2
net del interface swp3 ip address 100.64.2.1/24
net add bgp autonomous-system 65004
net add bgp router-id 10.0.0.4
net add bgp neighbor SPINE peer-group
net add bgp neighbor swp1-2 interface peer-group SPINE
net add bgp ipv4 unicast network 10.0.0.4/32
net del bgp ipv4 unicast network 100.64.2.0/24 
net add bgp neighbor SPINE capability extended-nexthop
net add interface swp5
net add bgp neighbor swp5 interface peer-group SPINE


net add interface swp4
net add bridge bridge
net add bridge bridge ports swp4,RED,BLUE,GREEN
net add bridge bridge vids 10,20,30

net add vxlan RED vxlan id 10010
net add vxlan RED bridge access 10
net add vxlan RED vxlan local-tunnelip 10.0.0.4

net add vxlan BLUE vxlan id 10020
net add vxlan BLUE bridge access 20
net add vxlan BLUE vxlan local-tunnelip 10.0.0.4

net add vxlan GREEN vxlan id 10030
net add vxlan GREEN bridge access 30
net add vxlan GREEN vxlan local-tunnelip 10.0.0.4

net add bgp l2vpn evpn advertise-all-vni
net add bgp l2vpn evpn neighbor SPINE activate

C5
net add loopback lo ip address 10.0.0.5/32
net add interface swp1-2
net del interface swp3 ip address 100.64.3.1/24
net add bgp autonomous-system 65005
net add bgp router-id 10.0.0.5
net add bgp neighbor SPINE peer-group
net add bgp neighbor swp1-2 interface peer-group SPINE
net add bgp ipv4 unicast network 10.0.0.5/32
net del bgp ipv4 unicast network 100.64.3.0/24 
net add bgp neighbor SPINE capability extended-nexthop
net add interface swp5
net add bgp neighbor swp5 interface peer-group SPINE

net add interface swp4
net add bridge bridge
net add bridge bridge ports swp4,RED,BLUE,GREEN
net add bridge bridge vids 10,20,30

net add vxlan RED vxlan id 10010
net add vxlan RED bridge access 10
net add vxlan RED vxlan local-tunnelip 10.0.0.5

net add vxlan BLUE vxlan id 10020
net add vxlan BLUE bridge access 20
net add vxlan BLUE vxlan local-tunnelip 10.0.0.5

net add vxlan GREEN vxlan id 10030
net add vxlan GREEN bridge access 30
net add vxlan GREEN vxlan local-tunnelip 10.0.0.5

net add bgp l2vpn evpn advertise-all-vni
net add bgp l2vpn evpn neighbor SPINE activate

R1
conf t
int f0/0
ip address 100.64.1.2 255.255.255.0
no shut
int lo0
ip address 10.1.1.1 255.255.255.255
exit
ip route 0.0.0.0 0.0.0.0 100.64.1.1
end

ip vrf RED
ip vrf BLUE
ip vrf GREEN

int lo0
ip vrf forwarding RED
ip address 10.10.1.1 255.255.255.255

int lo1
ip vrf forwarding BLUE
ip address 10.20.1.1 255.255.255.255

int lo2
ip vrf forwarding GREEN
ip address 10.30.1.1 255.255.255.255

int f0/0
no shut
int f0/0.10
encapsulation dot1q 10
ip vrf forwarding RED
ip address 10.0.27.1 255.255.255.248

int f0/0.20
encapsulation dot1q 20
ip vrf forwarding BLUE
ip address 10.0.65.1 255.255.255.248

int f0/0.30
encapsulation dot1q 30
ip vrf forwarding GREEN
ip address 10.0.54.1 255.255.255.248

router ospf 100 vrf RED
router-id 10.10.1.1
network 0.0.0.0 255.255.255.255 area 0

router ospf 200 vrf BLUE
router-id 10.20.1.1
network 0.0.0.0 255.255.255.255 area 0

router ospf 300 vrf GREEN
router-id 10.30.1.1
network 0.0.0.0 255.255.255.255 area 0

R2
conf t
int f0/0
ip address 100.64.2.2 255.255.255.0
no shut
int lo0
ip address 10.2.2.2 255.255.255.255
exit
ip route 0.0.0.0 0.0.0.0 100.64.2.1
end

ip vrf RED
ip vrf BLUE
ip vrf GREEN

int lo0
ip vrf forwarding RED
ip address 10.10.2.2 255.255.255.255

int lo1
ip vrf forwarding BLUE
ip address 10.20.2.2 255.255.255.255

int lo2
ip vrf forwarding GREEN
ip address 10.30.2.2 255.255.255.255

int f0/0
no shut
int f0/0.10
encapsulation dot1q 10
ip vrf forwarding RED
ip address 10.0.27.2 255.255.255.248

int f0/0.20
encapsulation dot1q 20
ip vrf forwarding BLUE
ip address 10.0.65.2 255.255.255.248

int f0/0.30
encapsulation dot1q 30
ip vrf forwarding GREEN
ip address 10.0.54.2 255.255.255.248

router ospf 100 vrf RED
router-id 10.10.2.2
network 0.0.0.0 255.255.255.255 area 0

router ospf 200 vrf BLUE
router-id 10.20.2.2
network 0.0.0.0 255.255.255.255 area 0

router ospf 300 vrf GREEN
router-id 10.30.2.2
network 0.0.0.0 255.255.255.255 area 0

R3
conf t
int f0/0
ip address 100.64.3.2 255.255.255.0
no shut
int lo0
ip address 10.3.3.3 255.255.255.255
exit
ip route 0.0.0.0 0.0.0.0 100.64.3.1
end

ip vrf RED
ip vrf BLUE
ip vrf GREEN

int lo0
ip vrf forwarding RED
ip address 10.10.3.3 255.255.255.255

int lo1
ip vrf forwarding BLUE
ip address 10.20.3.3 255.255.255.255

int lo2
ip vrf forwarding GREEN
ip address 10.30.3.3 255.255.255.255

int f0/0
no shut
int f0/0.10
encapsulation dot1q 10
ip vrf forwarding RED
ip address 10.0.27.3 255.255.255.248

int f0/0.20
encapsulation dot1q 20
ip vrf forwarding BLUE
ip address 10.0.65.3 255.255.255.248

int f0/0.30
encapsulation dot1q 30
ip vrf forwarding GREEN
ip address 10.0.54.3 255.255.255.248

router ospf 100 vrf RED
router-id 10.10.3.3
network 0.0.0.0 255.255.255.255 area 0

router ospf 200 vrf BLUE
router-id 10.20.3.3
network 0.0.0.0 255.255.255.255 area 0

router ospf 300 vrf GREEN
router-id 10.30.3.3
network 0.0.0.0 255.255.255.255 area 0