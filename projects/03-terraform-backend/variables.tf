variable "project_id" {
  description = "Target Google Cloud project ID where the Terraform state bucket will be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID (6 to 30 lowercase letters, digits, or hyphens)."
  }
}

variable "bucket_name" {
  description = "Globally unique Google Cloud Storage bucket name dedicated to Terraform remote state."
  type        = string

  validation {
    condition = (
      can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name)) &&
      !can(regex("^goog|google", var.bucket_name)) &&
      !can(regex("\\.\\.", var.bucket_name))
    )
    error_message = "bucket_name must be 3-63 characters (lowercase letters, numbers, hyphens, underscores, dots) and comply with GCS naming rules."
  }
}

variable "region" {
  description = "Google Cloud region for the state bucket (us-central1 is eligible for the GCS Free Tier allowance)."
  type        = string
  default     = "us-central1"

  validation {
    condition     = var.region == "us-central1"
    error_message = "This lab requires region = \"us-central1\" to align with the Iowa infrastructure and Free Tier eligibility."
  }
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to retain noncurrent (overwritten) Terraform state object versions before automatic deletion."
  type        = number
  default     = 90

  validation {
    condition = (
      var.noncurrent_version_retention_days >= 30 &&
      var.noncurrent_version_retention_days <= 365 &&
      floor(var.noncurrent_version_retention_days) == var.noncurrent_version_retention_days
    )
    error_message = "noncurrent_version_retention_days must be an integer between 30 and 365 days."
  }
}
