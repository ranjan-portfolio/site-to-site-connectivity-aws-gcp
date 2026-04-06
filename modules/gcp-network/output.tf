# Output the allocated public IP addresses
output "vpn_gateway_ips" {
  value = [
    for interface in google_compute_ha_vpn_gateway.ha_gateway.vpn_interfaces : interface.ip_address
  ]
  description = "The two public IP addresses automatically assigned to the HA VPN gateway interfaces."
}