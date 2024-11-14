resource "google_compute_network" "peering_network" {
  project = var.project_id
  name                    = var.private-network-name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_global_address" "private_ip_address" {
  project = var.project_id
  name          = var.private-ip-address-name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.prefix_length
  network       = google_compute_network.peering_network.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = var.service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
resource "google_compute_firewall" "deny_all" {
  project = var.project_id
  name    = var.firewall_name
  network = google_compute_network.peering_network.name

  deny {
    protocol = var.protocol
  }

  direction = var.direction
  priority  = var.priority
  source_ranges = var.source_ranges
}

resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = var.sql_name
  region           = var.location
  database_version = var.database_version  
   depends_on = [google_service_networking_connection.default]
  settings {
    tier = var.tier
    

    backup_configuration {
      enabled            = var.enabled
      binary_log_enabled = var.binary_log_enabled

    }
    
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = google_compute_network.peering_network.id
      ssl_mode = var.ssl_mode
      require_ssl = var.require_ssl
    }

  }

  deletion_protection = var.deletion_protection
}
resource "google_sql_user" "myuser" {
  project  = var.project_id
  name     = var.sql_user_name
  password = var.sql_user_pass
  instance = google_sql_database_instance.instance.name
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  project = var.project_id
  peering              = google_service_networking_connection.default.peering
  network              = google_compute_network.peering_network.name
  import_custom_routes = var.import_custom_routes
  export_custom_routes = var.export_custom_routes
}