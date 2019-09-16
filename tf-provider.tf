provider "openstack" {
  user_name     = "someuser"
  tenant_name   = "sometenant"
  password      = "somepassword"
  auth_url      = "https://acme-url.openstack.com:5000/v2.0"
  region        = "br-sp1"
}
