resource "openstack_networking_network_v2" "os-net-int1" {
  name										= "os-net-int1"
  region                  = "br-sp1"
  shared                  = false
  port_security_enabled   = true
  transparent_vlan        = false
  admin_state_up 					= "true"
  external       					= "false"
}
resource "openstack_networking_subnet_v2" "os-subnet1" {
	name       							= "os-subnet1"
  region          				= "br-sp1"
  enable_dhcp     				= true
  gateway_ip      				= "192.168.199.1"
  cidr       							= "192.168.199.0/24"
  ip_version 							= 4
  network_id 							= "${openstack_networking_network_v2.os-net-int1.id}"
  
  dns_nameservers = [
    "8.8.8.8",
    "8.8.4.4"
    ]

  allocation_pool {
    start   = "192.168.199.100"
    end = "192.168.199.199"
  }
}

resource "openstack_networking_router_v2" "os-router1" {
  name                		= "os-router1"
  region                  = "br-sp1"
  # enable_snat             = true
  admin_state_up      		= true
  external_network_id 		= "4ab8df8e-bb3d-40f8-b817-103557d84639" # public301
}

resource "openstack_networking_router_interface_v2" "os-router-int1" {
  region    							= "br-sp1"
  subnet_id 							= "${openstack_networking_subnet_v2.os-subnet1.id}"
  router_id 							= "${openstack_networking_router_v2.os-router1.id}"
}

resource "openstack_networking_floatingip_v2" "os-net-fip1" {
  region    							= "br-sp1"
  pool 										= "public301"
}