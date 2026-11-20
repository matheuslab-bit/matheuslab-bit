variable "project_id" {
  description = "Target Google Cloud project ID where the Lab 02 resources are provisioned."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID (6 to 30 lowercase letters, digits, or hyphens)."
  }
}

variable "zone" {
  description = "Iowa zone for the VM (us-central1 is eligible for the Compute Engine Free Tier)."
  type        = string
  default     = "us-central1-a"

  validation {
    condition     = can(regex("^us-central1-[abcf]$", var.zone))
    error_message = "zone must be a us-central1 zone: a, b, c, or f."
  }
}
