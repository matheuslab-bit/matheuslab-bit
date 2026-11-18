
output "vpc_name" {
  description = "Nome da rede VPC"
  value       = google_compute_network.portfolio_vpc.name
}

output "vpc_id" {
  description = "Identificador da rede VPC"
  value       = google_compute_network.portfolio_vpc.id
}

output "subnet_name" {
  description = "Nome da sub-rede"
  value       = google_compute_subnetwork.portfolio_subnet.name
}

output "subnet_cidr" {
  description = "Faixa de endereços IP da sub-rede"
  value       = google_compute_subnetwork.portfolio_subnet.ip_cidr_range
}

output "subnet_region" {
  description = "Região da sub-rede"
  value       = google_compute_subnetwork.portfolio_subnet.region
}
