
resource "google_compute_instance" "vm_instance" {
  name         = "my-gcp-vm"
  machine_type = "e2-medium" # Similar to t3.medium
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # OS Image
    }
  }

  network_interface {
    subnetwork = var.ec2_subnet_id

    # Adding an empty access_config block assigns a public IP
    access_config {
    }
  }

  metadata = {
    ssh-keys = "user:${file(pathexpand("~/.ssh/id_rsa.pub"))}" # Path to your public SSH key
  }
}