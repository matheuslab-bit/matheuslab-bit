resource "google_storage_bucket" "terraform_state" {
  #checkov:skip=CKV_GCP_62:Usage logs would need a second log bucket; bucket changes are already recorded by Cloud Audit Logs (Admin Activity).
  project                     = var.project_id
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  deletion_policy             = "PREVENT"

  labels = {
    lab        = "03-terraform-backend"
    managed_by = "terraform"
    purpose    = "terraform-remote-state"
  }

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  # Delete only noncurrent (archived) state versions older than the retention window.
  # The active (live) Terraform state version is never deleted by this rule.
  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = var.noncurrent_version_retention_days
      with_state                 = "ARCHIVED"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
