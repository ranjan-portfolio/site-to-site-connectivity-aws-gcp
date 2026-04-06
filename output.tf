output "gcp_vm_private_ip" {
  value = module.gcp-ec2.gcp_private_ip
}

output "aws_ec2_private_ip" {
  value = module.ec2.ec2_private_ip
}