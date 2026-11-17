variable "project_id" {
  description = "Existing Google Cloud project ID. Billing must already be enabled."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Google Cloud region for the subnet and regional resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Compute Engine zone. It must belong to the selected region."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the custom VPC network."
  type        = string
  default     = "gcp-secure-vpc"
}

variable "subnet_name" {
  description = "Name of the private subnet."
  type        = string
  default     = "gcp-secure-subnet"
}

variable "subnet_cidr" {
  description = "IPv4 CIDR range for the subnet."
  type        = string
  default     = "10.20.0.0/24"
}

variable "instance_name" {
  description = "Name of the private Debian administration VM."
  type        = string
  default     = "secure-admin-vm"
}

variable "machine_type" {
  description = "Compute Engine machine type. Check current regional pricing before deployment."
  type        = string
  default     = "e2-micro"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_size_gb >= 10
    error_message = "boot_disk_size_gb must be at least 10 GB."
  }
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs on the subnet. This can create additional charges."
  type        = bool
  default     = false
}

variable "enable_firewall_logging" {
  description = "Enable logging for the IAP SSH firewall rule. This can create additional charges."
  type        = bool
  default     = false
}
