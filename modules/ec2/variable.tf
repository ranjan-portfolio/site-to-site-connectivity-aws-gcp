/*variable "iam_instance_profile" {
  description = "this is instance profile name"
  type=string
}*/

variable "ec2_subnet_id"{
  description = "this is subnet where Ec2 will be launched"
  type=string
}

variable "ec2_vpc" {
  description = "This is the vpc where EC2 will be launched"
  type=string
}