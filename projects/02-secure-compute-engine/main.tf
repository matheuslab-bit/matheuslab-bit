# Read existing Lab 01 resources through the API, without accessing its state.
data "google_compute_network" "existing" {
  project = var.project_id
  name    = "portfolio-vpc"
}

data "google_compute_subnetwork" "existing" {
  project = var.project_id
  name    = "portfolio-subnet"
  region  = "southamerica-east1"
}

# No project roles, IAM bindings or service account keys are created.
resource "google_service_account" "vm" {
  project      = var.project_id
  account_id   = "lab02-secure-vm"
  display_name = "Lab 02 VM - no application permissions"
}

resource "google_compute_firewall" "iap_ssh" {
  project                 = var.project_id
  name                    = "lab02-allow-iap-ssh"
  network                 = data.google_compute_network.existing.self_link
  direction               = "INGRESS"
  priority                = 1000
  source_ranges           = ["35.235.240.0/20"]
  target_service_accounts = [google_service_account.vm.email]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Prevent lower-priority broad VPC allow rules from exposing SSH to this VM.
resource "google_compute_firewall" "deny_other_ssh" {
  project                 = var.project_id
  name                    = "lab02-deny-other-ssh"
  network                 = data.google_compute_network.existing.self_link
  direction               = "INGRESS"
  priority                = 1001
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.vm.email]

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = "lab02-secure-vm"
  zone         = var.zone
  machine_type = "e2-micro"

  labels = {
    lab        = "02-secure-compute-engine"
    managed_by = "terraform"
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.existing.self_link
    # Deliberately no access_config: no external IPv4 address.
    stack_type = "IPV4_ONLY"
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
    serial-port-enable     = "FALSE"
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    precondition {
      condition = (
        data.google_compute_subnetwork.existing.network == data.google_compute_network.existing.self_link &&
        data.google_compute_subnetwork.existing.ip_cidr_range == "10.10.0.0/24"
      )
      error_message = "A subnet deve pertencer à portfolio-vpc e usar 10.10.0.0/24."
    }
  }
}
