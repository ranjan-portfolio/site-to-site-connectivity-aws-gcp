terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# 1. Configure the GCP Provider
provider "google" {
  project = "seventh-odyssey-492321-t8" # Replace with your GCP Project ID
  region  = "us-central1"
  zone    = "us-central1-a"
  # credentials = file("service-account-key.json") # Optional: path to your JSON key
}


provider "aws" {
  region = "eu-west-2"
}