output "instance_name" {
  description = "Nome da VM privada implantada em Iowa."
  value       = google_compute_instance.vm.name
}

output "internal_ip" {
  description = "IP privado alocado na subnet de Iowa gerenciada pelo Lab 02."
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "subnet_name" {
  description = "Subnet exclusiva do Lab 02 em Iowa; a subnet de São Paulo é preservada."
  value       = google_compute_subnetwork.lab02.name
}

output "service_account_email" {
  description = "Service account dedicada da VM, sem papéis de aplicação concedidos pelo laboratório."
  value       = google_service_account.vm.email
}

output "ssh_command" {
  description = "Comando para conexão administrativa SSH via túnel IAP e OS Login."
  value       = "gcloud compute ssh ${google_compute_instance.vm.name} --project=${var.project_id} --zone=${var.zone} --tunnel-through-iap"
}
