
locals {
  local_mount_name="/bancs-home-local"
  common_mount_name="/bancs-home"
  availability_zone="eu-west-2a"
}


resource "aws_instance" "example" {
  ami="ami-087c9ba923d9765d8"
  instance_type = "t2.micro"
  //iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.ec2_sg_group.id]
  availability_zone = local.availability_zone
  subnet_id = var.ec2_subnet_id


  /*depends_on = [ aws_efs_file_system.bancs-home,aws_efs_mount_target.name ]

  user_data = <<-EOF
              #!/bin/bash
              while [ ! -b /dev/xvdf ]; do
                echo "Waiting for EBS volume..."
                sleep 2
              done
              blkid /dev/xvdf || mkfs -t ext4 /dev/xvdf      # format EBS volume
              mkdir -p ${local.local_mount_name}   # create mount point
              mount /dev/xvdf ${local.local_mount_name} 
              echo '/dev/xvdf ${local.local_mount_name}  ext4 defaults,nofail 0 2' >> /etc/fstab

              sudo yum install -y amazon-efs-utils
              mkdir -p ${local.common_mount_name}
              mount -t efs ${aws_efs_file_system.bancs-home.dns_name}:/ ${local.common_mount_name}
              echo '${aws_efs_file_system.bancs-home.dns_name}:/ ${local.common_mount_name} efs defaults,_netdev 0 0' >> /etc/fstab
              
              sudo useradd -m bancs
              sudo chown -R bancs:bancs ${local.common_mount_name}
              sudo chown -R bancs:bancs ${local.local_mount_name}
              EOF*/
 
}



resource "aws_security_group" "ec2_sg_group" {
  name="web-sg"
  vpc_id = var.ec2_vpc
  ingress {
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
  ingress {
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

   ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   # Allow all traffic from GCP subnet (ICMP ping + any app traffic)
  ingress {
    description = "All traffic from GCP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.0.0.0/16"]
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}

//To make ebs available in every availabilty zone loop in availablity zone
/*resource "aws_ebs_volume" "ebs" {
  availability_zone = data.aws_subnet.default.availability_zone
  size = 10
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  instance_id = aws_instance.example.id
  volume_id = aws_ebs_volume.ebs.id
}

resource "aws_efs_file_system" "bancs-home" {
  creation_token = "bancs-home"
}

// This only applies to one subnet , for all subnets need to create separate mount_targets
resource "aws_efs_mount_target" "name" {
  subnet_id = data.aws_subnet.default.id//only attaches to subnet
  file_system_id = aws_efs_file_system.bancs-home.id
  security_groups = [aws_security_group.ec2_sg_group.id]

}*/