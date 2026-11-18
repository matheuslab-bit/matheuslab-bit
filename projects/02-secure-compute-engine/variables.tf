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
  description = "Zona da VM na mesma região da subnet existente."
  type        = string
  default     = "southamerica-east1-a"

  validation {
    condition     = can(regex("^southamerica-east1-[abc]$", var.zone))
    error_message = "Use uma zona de southamerica-east1: a, b ou c."
  }
}
