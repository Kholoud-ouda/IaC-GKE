resource "google_compute_network" "vpc" {
  name                    = var.org_name
  project                 = var.project
  description             = ""
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1500
}

resource "google_compute_subnetwork" "this" {
  name                      = join("-", [var.org_name, "sub-0"])
  description               = ""
  ip_cidr_range             = var.cidr["main"]
  region                    = var.region 
  project                   = var.project
  network                   = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = join("-", [var.org_name , "pod-cidr"])
    ip_cidr_range = var.cidr["pod"]
  }
  secondary_ip_range {
    range_name    = join("-", [var.org_name , "svc-cidr"])
    ip_cidr_range = var.cidr["svc"]
  }
  ## Enable logging
  log_config {
    aggregation_interval    = "INTERVAL_10_MIN"
    flow_sampling           = 0.5
    metadata                = "INCLUDE_ALL_METADATA"
  }
}