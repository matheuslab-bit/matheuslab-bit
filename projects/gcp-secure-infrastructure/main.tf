locals {
  required_services = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iap.googleapis.com"
  ])

  common_labels = {
    environment = "learning"
    managed_by  = "terraform"
    project     = "gcp-secure-infrastructure"
  }
}

resource "google_project_service" "required" {
  for_each = local.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_network" "secure" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.required]
}

resource "google_compute_subnetwork" "private" {
  name                     = var.subnet_name
  region                   = var.region
  network                  = google_compute_network.secure.id
  ip_cidr_range             = var.subnet_cidr
  private_ip_google_access = true

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [true] : []

    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "iap_ssh" {
  name      = "${var.network_name}-allow-iap-ssh"
  network   = google_compute_network.secure.name
  direction = "INGRESS"
  priority  = 1000

  description   = "Allow SSH only through Identity-Aware Proxy TCP forwarding."
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  dynamic "log_config" {
    for_each = var.enable_firewall_logging ? [true] : []

    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }

  depends_on = [google_project_service.required]
}

resource "google_service_account" "vm" {
  account_id   = "gcp-secure-vm"
  display_name = "GCP Secure Infrastructure VM"
  description  = "Dedicated identity for the secure administration VM."

  depends_on = [google_project_service.required]
}

resource "google_project_iam_member" "vm_observability" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_compute_instance" "secure_vm" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  tags                      = ["iap-ssh"]
  labels                    = local.common_labels
  allow_stopping_for_update = true
  deletion_protection       = false

  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = var.boot_disk_size_gb
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
    # Intentionally no access_config block: the VM receives no external IP.
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

  depends_on = [
    google_project_iam_member.vm_observability,
    google_compute_firewall.iap_ssh
  ]
}

resource "google_monitoring_alert_policy" "high_cpu" {
  display_name = "Secure VM - high CPU utilization"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "CPU utilization above 80 percent for five minutes"

    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\" AND resource.labels.instance_id=\"${google_compute_instance.secure_vm.instance_id}\""

      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  documentation {
    content   = "CPU utilization for the secure administration VM has remained above 80 percent for five minutes. Review the instance and its workload."
    mime_type = "text/markdown"
  }

  user_labels = local.common_labels

  depends_on = [
    google_project_service.required,
    google_compute_instance.secure_vm
  ]
}
