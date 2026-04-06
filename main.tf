module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr                   = "10.0.0.0/16"
  vpc_public_subnet          = "10.0.10.0/24"
  vpc_private_subnet         = "10.0.20.0/24"
  availabilty_zone           = "eu-west-2a"
  gcp_vpn_gateway_ipaddress1 = module.gcp-network.vpn_gateway_ips[0]
  gcp_vpn_gateway_ipaddress2 = module.gcp-network.vpn_gateway_ips[1]
}

module "ec2" {
  source        = "./modules/ec2"
  ec2_subnet_id = module.vpc.public_subnet_id
  ec2_vpc       = module.vpc.vpc_id
}

module "gcp-vpc" {
  source = "./modules/gcp-vpc"

}

module "gcp-network" {
  source                      = "./modules/gcp-network"
  tunnel1_ip1                 = module.vpc.vpn_connection1_tunnel_ips[0]
  tunnel1_ip2                 = module.vpc.vpn_connection1_tunnel_ips[1]
  tunnel2_ip1                 = module.vpc.vpn_connection2_tunnel_ips[0]
  tunnel2_ip2                 = module.vpc.vpn_connection2_tunnel_ips[1]
  tunnel1_presared_key        = module.vpc.vpn1_tunnel1_psk
  tunnel2_presared_key        = module.vpc.vpn1_tunnel2_psk
  tunnel3_presared_key        = module.vpc.vpn1_tunnel3_psk
  tunnel4_presared_key        = module.vpc.vpn1_tunnel4_psk
  tunnel1_cgw1_inside_address = module.vpc.vpn1_tunnel1_cgw1_inside_ip
  tunnel1_cgw2_inside_address = module.vpc.vpn1_tunnel1_cgw2_inside_ip
  tunnel2_cgw1_inside_address = module.vpc.vpn1_tunnel2_cgw1_inside_ip
  tunnel2_cgw2_inside_address = module.vpc.vpn1_tunnel2_cgw2_inside_ip
  tunnel1_vgw1_inside_address = module.vpc.vpn1_tunnel1_vgw1_inside_ip
  tunnel1_vgw2_inside_address = module.vpc.vpn1_tunnel1_vgw2_inside_ip
  tunnel2_vgw1_inside_address = module.vpc.vpn1_tunnel2_vgw1_inside_ip
  tunnel2_vgw2_inside_address = module.vpc.vpn1_tunnel2_vgw2_inside_ip
  vpc_id                      = module.gcp-vpc.gcp_vpc_id

}
module "gcp-ec2" {
  source        = "./modules/gcp-ec2"
  ec2_subnet_id = module.gcp-vpc.public_subnet_id
}