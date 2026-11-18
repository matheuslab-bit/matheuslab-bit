
variable "project_id" {
  description = "ID do projeto no Google Cloud"
  type        = string
}

variable "region" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "southamerica-east1"
}

variable "network_name" {
  description = "Nome da rede VPC"
  type        = string
  default     = "portfolio-vpc"
}

variable "subnet_name" {
  description = "Nome da sub-rede"
  type        = string
  default     = "portfolio-subnet"
}

variable "subnet_cidr" {
  description = "Faixa de endereços IP da sub-rede"
  type        = string
  default     = "10.10.0.0/24"
}
