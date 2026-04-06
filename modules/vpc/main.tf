resource "aws_vpc" "my_aws_vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      "project_name"="site-to-site"
    }
}

resource "aws_subnet" "my_aws_public_subnet"{
    vpc_id=aws_vpc.my_aws_vpc.id
    cidr_block = var.vpc_public_subnet
    map_public_ip_on_launch = true
    availability_zone = var.availabilty_zone
    tags = {
      "project_name"="site-to-site"
    }
}

resource "aws_subnet" "my_aws_private_subnet" {
  vpc_id =  aws_vpc.my_aws_vpc.id
  cidr_block = var.vpc_private_subnet
  tags = {
      "project_name"="site-to-site"
    }
}

resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.my_aws_vpc.id
   tags = {
      "project_name"="site-to-site"
    }
}

resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      "project_name"="site-to-site"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.my_aws_public_subnet.id

    depends_on = [ aws_internet_gateway.igw ]

    tags = {
      "project_name"="site-to-site"
    }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.my_aws_public_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_aws_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.my_aws_private_subnet.id
  route_table_id = aws_route_table.private.id
}

//This is required for site to site connectivity

resource "aws_customer_gateway" "gateway1" {
  bgp_asn    = 64514
  ip_address = var.gcp_vpn_gateway_ipaddress1 # Your on-premises router IP1
  type       = "ipsec.1"
}

resource "aws_customer_gateway" "gateway2" {
  bgp_asn    = 64514
  ip_address = var.gcp_vpn_gateway_ipaddress2 # Your on-premises router IP2
  type       = "ipsec.1"
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.my_aws_vpc.id

}

//This is for router1
resource "aws_vpn_connection" "vpn_connection1" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.gateway1.id
  type                = "ipsec.1"
  static_routes_only  = false
  
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_startup_action               = "start"

  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_startup_action               = "start"
}
//This is for router2
resource "aws_vpn_connection" "vpn_connection2" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.gateway2.id
  type                = "ipsec.1"
  static_routes_only  = false

   tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_startup_action               = "start"

  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_startup_action               = "start"
}

resource "aws_vpn_gateway_route_propagation" "public_subnet_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpn_gateway_route_propagation" "private_subnet_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  route_table_id = aws_route_table.public.id
}