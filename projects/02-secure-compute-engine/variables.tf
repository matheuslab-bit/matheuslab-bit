variable "project_id" {
  description = "ID do projeto Google Cloud de destino onde os recursos do Lab 02 são provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Informe um ID de projeto Google Cloud válido (6 a 30 letras minúsculas, dígitos ou hífens)."
  }
}

variable "zone" {
  description = "Zona da VM em Iowa, região elegível ao Free Tier."
  type        = string
  default     = "us-central1-a"

  validation {
    condition     = can(regex("^us-central1-[abcf]$", var.zone))
    error_message = "Use uma zona de us-central1: a, b, c ou f."
  }
}
