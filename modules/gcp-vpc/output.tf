output "public_subnet_id" {
  value=google_compute_subnetwork.my_public_subnet.id
}

output "private_subnet_id" {
  value=google_compute_subnetwork.my_private_subnet.id
}

output "gcp_vpc_id" {
  value=google_compute_network.vpc_network.id
}



