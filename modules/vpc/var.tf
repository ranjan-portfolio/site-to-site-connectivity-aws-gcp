variable "vpc_cidr"{
    description="CIDR block for vpc"
    type = string
}

variable "vpc_public_subnet"{
    description = "CIDR block for public subnet"
    type = string
}

variable "vpc_private_subnet"{
    description="CIDR block for private subnet"
    type=string
}

variable "availabilty_zone"{
    description = "Avaliability zone"
    type=string
}

variable "gcp_vpn_gateway_ipaddress1"{
    description = "vpn gateway ip address 1"
    type=string
}

variable "gcp_vpn_gateway_ipaddress2"{
    description = "vpn gateway ip address 2"
    type=string
}

