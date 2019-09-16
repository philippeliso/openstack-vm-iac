resource "openstack_compute_instance_v2" "br-sp1-a-nix-devops1" {
  name            				= "br-sp1-a-nix-devops1"
  region              		= "br-sp1"
  availability_zone   		= "br-sp1-a"
  image_name          		= "CentOS-7 64Bits"
  flavor_name         		= "small.2GB"
  force_delete        		= false
  key_pair        				= "${openstack_compute_keypair_v2.os-kp-user.name}"
  security_groups 				= ["${openstack_compute_secgroup_v2.os-sg-default.name}"]
  # user_data       = "#cloud-config\nwrite_files:\n- path: /etc/ssh/sshd_config\ncontent: |\nPort 8083\nProtocol 2\nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\nUsePrivilegeSeparation yes\nKeyRegenerationInterval 3600\nServerKeyBits 1024\nSyslogFacility AUTH\nLogLevel INFO\nLoginGraceTime 120\nPermitRootLogin no\nStrictModes yes\nRSAAuthentication yes\nPubkeyAuthentication yes\nIgnoreRhosts yes\nRhostsRSAAuthentication no\nHostbasedAuthentication no\nPermitEmptyPasswords no\nChallengeResponseAuthentication no\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog yes\nTCPKeepAlive yes\nAcceptEnv LANG LC_*\nSubsystem sftp /usr/lib/openssh/sftp-server\nUsePAM yes"
  network {
    name 						= "os-net-int1"
    port 						= "${openstack_networking_port_v2.os-np-devops-1.id}"
    access_network 	= false
  }
}

resource "openstack_compute_floatingip_associate_v2" "os-fip-devops1" {
  region      						= "br-sp1"
  floating_ip 						= "${openstack_networking_floatingip_v2.os-net-fip1.address}"
  instance_id 						= "${openstack_compute_instance_v2.br-sp1-a-nix-devops1.id}"

  depends_on 							= ["openstack_networking_router_interface_v2.os-router-int1"]
}

resource "openstack_networking_port_v2" "os-np-devops-1" {
  name               			= "os-np-devops-1"
  region                 	= "br-sp1"
  admin_state_up     			= "true"
  port_security_enabled  	= true	
  network_id         			= "${openstack_networking_network_v2.os-net-int1.id}"
  security_group_ids 			= ["${openstack_compute_secgroup_v2.os-sg-default.id}"]

  fixed_ip {
    subnet_id  = "${openstack_networking_subnet_v2.os-subnet1.id}"
    ip_address = "192.168.199.10"
  }
}

resource "openstack_blockstorage_volume_v2" "os-blks-devops1" {
  name                    = "os-blks-devops1"
  region            			= "br-sp1"
  volume_type       			= "Gold"
  size 										= 54 # GB

  metadata = {
      attached_mode = "rw"
      readonly      = "False"
  }
}

resource "openstack_compute_volume_attach_v2" "attached" {
  region 								= "br-sp1"
  instance_id 					= "${openstack_compute_instance_v2.br-sp1-a-nix-devops1.id}"
  volume_id   					= "${openstack_blockstorage_volume_v2.os-blks-devops1.id}"
}