resource "openstack_compute_secgroup_v2" "os-sg-default" {
  name        = "os-sg-default"
  region      = "br-sp1"
  description = "A Default Security Group rules"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
    self        = false
  }

  rule {
    from_port   = 8083
    to_port     = 8083
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
    self        = false
  }
}