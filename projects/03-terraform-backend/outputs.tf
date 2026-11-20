output "bucket_name" {
  description = "Name of the GCS bucket created for Terraform remote state."
  value       = google_storage_bucket.terraform_state.name
}

output "bucket_url" {
  description = "GCS URI (gs://...) of the Terraform remote state bucket."
  value       = google_storage_bucket.terraform_state.url
}

output "bucket_self_link" {
  description = "Self-link URI of the Terraform remote state bucket."
  value       = google_storage_bucket.terraform_state.self_link
}

output "bucket_location" {
  description = "Region where the Terraform remote state bucket is located."
  value       = google_storage_bucket.terraform_state.location
}

output "backend_config_example" {
  description = "Example backend configuration block to use in other portfolio labs."
  value       = <<-EOT
    terraform {
      backend "gcs" {
        bucket = "${google_storage_bucket.terraform_state.name}"
        prefix = "labs/<lab-name>"
      }
    }
  EOT
}
