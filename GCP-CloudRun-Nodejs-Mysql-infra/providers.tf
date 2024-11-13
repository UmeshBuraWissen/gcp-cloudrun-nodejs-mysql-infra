provider "google" {
  region = "us-central1"
  scopes      = ["https://www.googleapis.com/auth/cloud-platform"]
}
terraform {
  required_providers {
    google = {
      version = "~> 5.34.0"
    }
    google-beta = {
      version = "6.4.0"
    }
  }
}
