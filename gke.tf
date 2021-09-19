resource "google_project_service" "container_api_network" {
  project                    = var.project
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_container_cluster" "this" {
  name                     = var.org_name
  location                 = var.region
  project                  = var.project
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.this.self_link
  remove_default_node_pool = true
  initial_node_count       = var.node_count
  enable_shielded_nodes    = true
  
  #### Set nodes configuration in one region only ####
  node_locations         = [join("-", [var.region , "a" ]),join("-", [var.region , "b" ]) ]

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.this.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.this.secondary_ip_range[1].range_name
  }
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "ALL"
    }
  }
  
 lifecycle {
    ignore_changes = [
        master_version,
        node_version
    ]
  }
}

resource "google_container_node_pool" "this" {
  name               = join("-", [var.org_name , "pool" ])
  location           = var.region
  initial_node_count = var.node_count
  cluster            = google_container_cluster.this.name
  project            = var.project

  autoscaling {
    min_node_count = var.asg_mini
    max_node_count = var.asg_max
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
  node_config {
    machine_type = var.gke_vm_type
    image_type   = "COS_CONTAINERD"
    oauth_scopes = local.node_pool_oauth_scopes
    shielded_instance_config {
      enable_secure_boot = true
    }
    
    tags = ["sunday-gke"]
  }
  lifecycle {
    ignore_changes = [
        version
    ]
  }
}
