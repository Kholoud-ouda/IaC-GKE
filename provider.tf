
provider "google" {
}

terraform {
  backend "gcs" {
    bucket  = "sunday-tf-state"
    prefix  = "terraform/state"
  }
}