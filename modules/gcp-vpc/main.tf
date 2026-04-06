
# 2. Create a Custom VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-vpc"
  auto_create_subnetworks = false # Set to false to create custom subnets
}

# 3. Create a Subnet within the VPC
resource "google_compute_subnetwork" "my_public_subnet" {
  name          = "my-custom-public-subnet"
  ip_cidr_range = "172.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "my_private_subnet" {
  name          = "my-custom-private-subnet"
  ip_cidr_range = "172.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# 4. Create a Firewall Rule to allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["0.0.0.0/0"] # Be specific for better security
}

# 5. Create the VM Instance (GCP equivalent of EC2)








