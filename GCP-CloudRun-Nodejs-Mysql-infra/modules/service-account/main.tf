locals {
  service_account_email = google_service_account.my_service_account.email
}
resource "google_service_account" "my_service_account" {
  project = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
}
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.my_service_account.name
  role               = var.role
  members = ["serviceAccount:${local.service_account_email}"]
  depends_on = [ google_service_account.my_service_account ]
}

