variable "project_id" {
  description = "Target Google Cloud project ID."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID (6 to 30 lowercase letters, digits, or hyphens)."
  }
}

variable "region" {
  description = "Region where the subnet is created."
  type        = string
  default     = "southamerica-east1"
}

variable "network_name" {
  description = "Name of the custom-mode VPC network."
  type        = string
  default     = "portfolio-vpc"
}

variable "subnet_name" {
  description = "Name of the regional subnet."
  type        = string
  default     = "portfolio-subnet"
}

variable "subnet_cidr" {
  description = "Primary IPv4 CIDR range of the subnet."
  type        = string
  default     = "10.10.0.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid IPv4 CIDR range (for example, 10.10.0.0/24)."
  }
}
