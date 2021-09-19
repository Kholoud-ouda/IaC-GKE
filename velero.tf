
resource "google_storage_bucket" "velero" {
  name          = "${var.org_name}_velero"
  location      = var.region
  force_destroy = true
  project       = var.project
  storage_class = "REGIONAL"
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 7

    }
    action {
      type = "Delete"
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

locals {
  namespace = "velero"
}


resource "google_service_account" "velero" {
  project      =  var.project
  account_id   = "${var.org_name}-velero"
  display_name = "Velero account for ${var.org_name}"
}

/*resource "google_service_account_key" "velero" {
  service_account_id = "${google_service_account.velero.name}"
}
*/

resource "google_storage_bucket_iam_binding" "ark_bucket_iam" {
  bucket = "${google_storage_bucket.velero.name}"
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.velero.email}"
  ]

  # don't destroy buckets containing backup data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}