output "vpc_id" {
  value = aws_vpc.my_aws_vpc.id
}

output "public_subnet_id" {
    value=aws_subnet.my_aws_public_subnet.id
}

output "vpc_private_subnet_id" {
  value=aws_subnet.my_aws_private_subnet.id
}

output "vpn_connection1_tunnel_ips" {
  value = [
    aws_vpn_connection.vpn_connection1.tunnel1_address,
    aws_vpn_connection.vpn_connection1.tunnel2_address
  ]
}

output "vpn_connection2_tunnel_ips" {
  value = [
    aws_vpn_connection.vpn_connection2.tunnel1_address,
    aws_vpn_connection.vpn_connection2.tunnel2_address
  ]
}

output "vpn1_tunnel1_psk" {
  value     = aws_vpn_connection.vpn_connection1.tunnel1_preshared_key
  sensitive = true
}

output "vpn1_tunnel2_psk" {
  value     = aws_vpn_connection.vpn_connection1.tunnel2_preshared_key
  sensitive = true
}

output "vpn1_tunnel3_psk" {
  value     = aws_vpn_connection.vpn_connection2.tunnel1_preshared_key
  sensitive = true
}

output "vpn1_tunnel4_psk" {
  value     = aws_vpn_connection.vpn_connection2.tunnel2_preshared_key
  sensitive = true
}

output "vpn1_tunnel1_cgw1_inside_ip" {
  value = aws_vpn_connection.vpn_connection1.tunnel1_cgw_inside_address
}
output "vpn1_tunnel1_vgw1_inside_ip" {
  value = aws_vpn_connection.vpn_connection1.tunnel1_vgw_inside_address
}

output "vpn1_tunnel1_cgw2_inside_ip" {
  value = aws_vpn_connection.vpn_connection1.tunnel2_cgw_inside_address
}
output "vpn1_tunnel1_vgw2_inside_ip" {
  value = aws_vpn_connection.vpn_connection1.tunnel2_vgw_inside_address
}

output "vpn1_tunnel2_cgw1_inside_ip" {
  value = aws_vpn_connection.vpn_connection2.tunnel1_cgw_inside_address
}
output "vpn1_tunnel2_vgw1_inside_ip" {
  value = aws_vpn_connection.vpn_connection2.tunnel1_vgw_inside_address
}
output "vpn1_tunnel2_cgw2_inside_ip" {
  value = aws_vpn_connection.vpn_connection2.tunnel2_cgw_inside_address
}
output "vpn1_tunnel2_vgw2_inside_ip" {
  value = aws_vpn_connection.vpn_connection2.tunnel2_vgw_inside_address
}
