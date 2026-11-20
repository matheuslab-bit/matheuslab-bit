output "project_id" {
  description = "Google Cloud project used by this deployment."
  value       = var.project_id
}

output "vpc_name" {
  description = "Name of the custom VPC network."
  value       = google_compute_network.secure.name
}

output "subnet_name" {
  description = "Name of the private subnet."
  value       = google_compute_subnetwork.private.name
}

output "vm_name" {
  description = "Name of the private Compute Engine VM."
  value       = google_compute_instance.secure_vm.name
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM. No external IP is assigned."
  value       = google_compute_instance.secure_vm.network_interface[0].network_ip
}

output "vm_zone" {
  description = "Zone where the VM was created."
  value       = google_compute_instance.secure_vm.zone
}

output "iap_ssh_command" {
  description = "Command to connect to the VM through IAP. The caller must have IAP and OS Login permissions."
  value       = "gcloud compute ssh ${google_compute_instance.secure_vm.name} --project=${var.project_id} --zone=${var.zone} --tunnel-through-iap"
}
