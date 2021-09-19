variable "org_name" {
    type= string
    default = "sunday"
}

variable "project" {
    type = string
    default = "glowing-box-326415"
}

variable "region" {
    type = string
    default = "northamerica-northeast1" 
}

variable "cidr" {
   type = map
   default = {
    "main"   = "10.0.4.0/22"
    "pod"    = "10.4.0.0/14"
    "svc"    = "10.0.32.0/20"
    "master" = "10.10.11.0/28"
    }
}


########## GKE variables #########
variable "node_count" {
    default = 1
}

variable "asg_mini" {
    default = 1
}

variable "asg_max" {
    default = 3
}

locals {
  node_pool_oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
  google_compute_security_policy_sqli_rule_expression_list = <<EOT
    evaluatePreconfiguredExpr('sqli-stable',[
      'owasp-crs-v030001-id942110-sqli',
      'owasp-crs-v030001-id942120-sqli',
      'owasp-crs-v030001-id942150-sqli',
      'owasp-crs-v030001-id942180-sqli',
      'owasp-crs-v030001-id942200-sqli',
      'owasp-crs-v030001-id942210-sqli',
      'owasp-crs-v030001-id942260-sqli',
      'owasp-crs-v030001-id942300-sqli',
      'owasp-crs-v030001-id942310-sqli',
      'owasp-crs-v030001-id942330-sqli',
      'owasp-crs-v030001-id942340-sqli',
      'owasp-crs-v030001-id942380-sqli',
      'owasp-crs-v030001-id942390-sqli',
      'owasp-crs-v030001-id942400-sqli',
      'owasp-crs-v030001-id942410-sqli',
      'owasp-crs-v030001-id942430-sqli',
      'owasp-crs-v030001-id942440-sqli',
      'owasp-crs-v030001-id942450-sqli',
      'owasp-crs-v030001-id942251-sqli',
      'owasp-crs-v030001-id942420-sqli',
      'owasp-crs-v030001-id942431-sqli',
      'owasp-crs-v030001-id942460-sqli',
      'owasp-crs-v030001-id942421-sqli',
      'owasp-crs-v030001-id942432-sqli'
    ])
EOT

}

variable "gke_vm_type" {
    type = string 
    default = "e2-medium"
}