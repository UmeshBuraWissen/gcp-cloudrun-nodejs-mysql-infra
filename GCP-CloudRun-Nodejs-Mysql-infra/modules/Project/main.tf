resource "google_project" "my_project" {
  name                = var.name
  project_id          = var.project_id
  org_id              = var.org_id
  auto_create_network = false
  count               = var.enable_network ? 1 : 0

}


resource "google_project_iam_audit_config" "project_good_audit" {
  count = length(google_project.my_project)
  project = google_project.my_project[count.index].id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}