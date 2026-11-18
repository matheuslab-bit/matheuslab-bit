variable "zone" {
  description = "Zona da VM na mesma região da subnet existente."
  type        = string
  default     = "southamerica-east1-a"

  validation {
    condition     = can(regex("^southamerica-east1-[abc]$", var.zone))
    error_message = "Use uma zona de southamerica-east1: a, b ou c."
  }
}
