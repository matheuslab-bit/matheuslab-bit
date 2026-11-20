output "vpc_name" {
  description = "Name of the VPC network."
  value       = google_compute_network.portfolio_vpc.name
}

output "vpc_id" {
  description = "Identifier of the VPC network."
  value       = google_compute_network.portfolio_vpc.id
}

output "subnet_name" {
  description = "Name of the subnet."
  value       = google_compute_subnetwork.portfolio_subnet.name
}

output "subnet_cidr" {
  description = "IPv4 CIDR range of the subnet."
  value       = google_compute_subnetwork.portfolio_subnet.ip_cidr_range
}

output "subnet_region" {
  description = "Region of the subnet."
  value       = google_compute_subnetwork.portfolio_subnet.region
}
