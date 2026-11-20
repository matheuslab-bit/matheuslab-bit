# Custom-mode VPC: subnets are never created automatically, so every CIDR
# range in the network is planned and declared explicitly.
resource "google_compute_network" "portfolio_vpc" {
  #checkov:skip=CKV2_GCP_18:Firewall rules are owned by each workload lab (Lab 02 defines IAP allow/deny rules) instead of this network lab.
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "portfolio_subnet" {
  #checkov:skip=CKV_GCP_26:VPC Flow Logs are deferred to the planned monitoring lab to avoid log ingestion costs in a learning environment.
  #checkov:skip=CKV_GCP_74:No workloads run in this subnet yet; Private Google Access will be enabled when a workload needs Google APIs.
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.portfolio_vpc.id
}
