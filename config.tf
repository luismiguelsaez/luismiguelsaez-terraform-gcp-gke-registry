terraform {
  required_version = "~> 0.14.7"
}

provider "google" {
  project     = var.project
  region      = var.region
}

data "google_client_config" "default" {}
