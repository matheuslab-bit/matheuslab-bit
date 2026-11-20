output "instance_name" {
  description = "Name of the private VM deployed in Iowa."
  value       = google_compute_instance.vm.name
}

output "internal_ip" {
  description = "Private IP allocated from the Iowa subnet managed by Lab 02."
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "subnet_name" {
  description = "Dedicated Lab 02 subnet in Iowa; the São Paulo subnet from Lab 01 is preserved."
  value       = google_compute_subnetwork.lab02.name
}

output "service_account_email" {
  description = "Dedicated VM service account, with no application roles granted by this lab."
  value       = google_service_account.vm.email
}

output "ssh_command" {
  description = "Administrative SSH command through an IAP tunnel and OS Login."
  value       = "gcloud compute ssh ${google_compute_instance.vm.name} --project=${var.project_id} --zone=${var.zone} --tunnel-through-iap"
}
