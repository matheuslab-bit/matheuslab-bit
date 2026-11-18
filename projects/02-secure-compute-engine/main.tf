# Read existing Lab 01 resources through the API, without accessing its state.
data "google_compute_network" "existing" {
  project = var.project_id
  name    = "portfolio-vpc"
}

resource "google_compute_subnetwork" "lab02" {
  project                  = var.project_id
  name                     = "lab02-iowa-subnet"
  region                   = "us-central1"
  ip_cidr_range            = "10.20.0.0/24"
  network                  = data.google_compute_network.existing.self_link
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = false
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
  priority                = 900
  source_ranges           = ["35.235.240.0/20"]
  target_service_accounts = [google_service_account.vm.email]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Deny non-IAP SSH before common priority-1000 VPC allow rules.
resource "google_compute_firewall" "deny_other_ssh" {
  project                 = var.project_id
  name                    = "lab02-deny-other-ssh"
  network                 = data.google_compute_network.existing.self_link
  direction               = "INGRESS"
  priority                = 901
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.vm.email]

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "vm" {
  # The shared service account does not imply a VM dependency on the firewalls.
  # Install both SSH controls before creating the VM.
  depends_on = [
    google_compute_firewall.iap_ssh,
    google_compute_firewall.deny_other_ssh,
  ]
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
    subnetwork = google_compute_subnetwork.lab02.self_link
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
    provisioning_model  = "STANDARD"
  }

  lifecycle {
    precondition {
      condition = (
        google_compute_subnetwork.lab02.network == data.google_compute_network.existing.self_link &&
        google_compute_subnetwork.lab02.ip_cidr_range == "10.20.0.0/24"
      )
      error_message = "A subnet de Iowa deve pertencer à portfolio-vpc e usar 10.20.0.0/24."
    }
  }
}
