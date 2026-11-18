variable "project_id" {
  description = "Projeto-alvo fixo deste laboratório."
  type        = string
  default     = "driven-surface-513117-k0"

  validation {
    condition     = var.project_id == "driven-surface-513117-k0"
    error_message = "Este laboratório deve usar o projeto driven-surface-513117-k0."
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
