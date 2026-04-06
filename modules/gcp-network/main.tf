// This is required for Site-to-Site connectivity

resource "google_compute_router" "cloud_router" {
  name="gcp-cloud-router"
  network = var.vpc_id
  region  = "us-central1"

  bgp {
    # You must manually specify this value, this is what you have given in GCP side
    asn = 64514 
  }
  
}

# Create the HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  name    = "my-ha-vpn-gw"
  network = var.vpc_id
  region  = "us-central1"
  
}




resource "google_compute_external_vpn_gateway" "aws_gateway" {
  name            = "aws-side-gateway"
  redundancy_type = "FOUR_IPS_REDUNDANCY" # Use 4 for full HA, or 2 for a simpler test
  description     = "External gateway representing AWS VPN endpoints"

  interface {
    id         = 0
    ip_address = var.tunnel1_ip1 # Replace with your tunnel output
  }
  interface {
    id         = 1
    ip_address = var.tunnel1_ip2 # Replace with your tunnel output
  }
  interface {
    id         = 2
    ip_address = var.tunnel2_ip1 # Replace with your tunnel output
  }

  interface {
    id         = 3
    ip_address = var.tunnel2_ip2 # Replace with your tunnel output
  }
  # Add IDs 2 and 3 if you are setting up all 4 tunnels
}

#tunnel 1
resource "google_compute_vpn_tunnel" "tunnel_1" {
  name                            = "aws-tunnel-1"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.aws_gateway.id
  peer_external_gateway_interface = 0
  vpn_gateway_interface           = 0
  shared_secret                   = var.tunnel1_presared_key //As taken from AWS configuration file
  router                          = google_compute_router.cloud_router.id
}

resource "google_compute_vpn_tunnel" "tunnel_2" {
  name                            = "aws-tunnel-2"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.aws_gateway.id
  peer_external_gateway_interface = 1
  vpn_gateway_interface           = 0
  shared_secret                   = var.tunnel2_presared_key //As taken from AWS configuration file
  router                          = google_compute_router.cloud_router.id
}

resource "google_compute_vpn_tunnel" "tunnel_3" {
  name                            = "aws-tunnel-3"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.aws_gateway.id
  peer_external_gateway_interface = 2
  vpn_gateway_interface           = 1
  shared_secret                   = var.tunnel3_presared_key //As taken from AWS configuration file
  router                          = google_compute_router.cloud_router.id
}

resource "google_compute_vpn_tunnel" "tunnel_4" {
  name                            = "aws-tunnel-4"
  region                          = "us-central1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.aws_gateway.id
  peer_external_gateway_interface = 3
  vpn_gateway_interface           = 1
  shared_secret                   = var.tunnel4_presared_key//As taken from AWS configuration file
  router                          = google_compute_router.cloud_router.id
}

# 1. Router Interface for Tunnel 1
resource "google_compute_router_interface" "if_1" {
  name       = "if-tunnel-1"
  router     = google_compute_router.cloud_router.name
  region     = "us-central1"
  # This is the GCP-side BGP IP from AWS Connection 1, Tunnel 1
  ip_range   ="${var.tunnel1_cgw1_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_1.name
}

# 2. BGP Peer for Tunnel 1
resource "google_compute_router_peer" "peer_1" {
  name            = "peer-tunnel-1"
  router          = google_compute_router.cloud_router.name
  region          = "us-central1"
  peer_asn        = 64512 # AWS Side ASN (Default)
  # This is the AWS-side BGP IP from AWS Connection 1, Tunnel 1
  peer_ip_address = var.tunnel1_vgw1_inside_address
  interface       = google_compute_router_interface.if_1.name
}

# 1. Router Interface for Tunnel 2
resource "google_compute_router_interface" "if_2" {
  name       = "if-tunnel-2"
  router     = google_compute_router.cloud_router.name
  region     = "us-central1"
  # This is the GCP-side BGP IP from AWS Connection 1, Tunnel 1
  ip_range   = "${var.tunnel1_cgw2_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_2.name
}

# 2. BGP Peer for Tunnel 2
resource "google_compute_router_peer" "peer_2" {
  name            = "peer-tunnel-2"
  router          = google_compute_router.cloud_router.name
  region          = "us-central1"
  peer_asn        = 64512 # AWS Side ASN (Default)
  # This is the AWS-side BGP IP from AWS Connection 1, Tunnel 1
  peer_ip_address = var.tunnel1_vgw2_inside_address
  interface       = google_compute_router_interface.if_2.name
}

# 1. Router Interface for Tunnel 3
resource "google_compute_router_interface" "if_3" {
  name       = "if-tunnel-3"
  router     = google_compute_router.cloud_router.name
  region     = "us-central1"
  # This is the GCP-side BGP IP from AWS Connection 1, Tunnel 1
  ip_range   = "${var.tunnel2_cgw1_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_3.name
}

# 2. BGP Peer for Tunnel 3
resource "google_compute_router_peer" "peer_3" {
  name            = "peer-tunnel-3"
  router          = google_compute_router.cloud_router.name
  region          = "us-central1"
  peer_asn        = 64512 # AWS Side ASN (Default)
  # This is the AWS-side BGP IP from AWS Connection 1, Tunnel 1
  peer_ip_address = var.tunnel2_vgw1_inside_address
  interface       = google_compute_router_interface.if_3.name
}

# 1. Router Interface for Tunnel 4
resource "google_compute_router_interface" "if_4" {
  name       = "if-tunnel-4"
  router     = google_compute_router.cloud_router.name
  region     = "us-central1"
  # This is the GCP-side BGP IP from AWS Connection 1, Tunnel 1
  ip_range   = "${var.tunnel2_cgw2_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_4.name
}

# 2. BGP Peer for Tunnel 4
resource "google_compute_router_peer" "peer_4" {
  name            = "peer-tunnel-4"
  router          = google_compute_router.cloud_router.name
  region          = "us-central1"
  peer_asn        = 64512 # AWS Side ASN (Default)
  # This is the AWS-side BGP IP from AWS Connection 1, Tunnel 1
  peer_ip_address = var.tunnel2_vgw2_inside_address
  interface       = google_compute_router_interface.if_4.name
}