resource "google_cloud_run_domain_mapping" "default" {
  project      = var.project_id
  location = var.location
  name     = var.name
  metadata {
    namespace = var.metadata_namespace
  }

  spec {
    route_name = var.route_name
  }
}