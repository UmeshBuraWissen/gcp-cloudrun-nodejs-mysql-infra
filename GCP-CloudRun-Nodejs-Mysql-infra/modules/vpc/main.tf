resource "google_compute_network" "network" {
  name                                      = var.network_name
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  project                                   = var.project_id
  description                               = var.description
  delete_default_routes_on_create           = var.delete_default_internet_gateway_routes
  mtu                                       = var.mtu
}
#Subnet
resource "google_compute_subnetwork" "subnetwork" {
name          = var.subnet_name
ip_cidr_range = var.ip_cidr_range
region        = var.region
project                                   = var.project_id
network       = google_compute_network.network.name
secondary_ip_range = [
    for range in var.secondary_ip_range :
    {
      range_name    = range.range_name
      ip_cidr_range = range.ip_cidr_range
    }
  ]
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5  # Adjust sampling rate (0.0 to 1.0)
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
depends_on = [ google_compute_network.network ]
}
#Firewall
resource "google_compute_firewall" "allow-http" {
  name    = var.firewall_name
  project                                   = var.project_id
  network = google_compute_network.network.name

  allow {
        protocol = var.allow.protocol
        ports    = var.allow.ports
  }

  source_ranges = var.source_ranges
  direction     = var.direction
  target_tags   = var.target_tags
  depends_on = [ google_compute_network.network ]
}
