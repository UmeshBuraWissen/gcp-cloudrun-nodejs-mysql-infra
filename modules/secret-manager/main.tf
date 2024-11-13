resource "google_secret_manager_secret" "secret-basic" {
  secret_id = var.secret_id
      project     = var.project

  labels = {
    label = var.label
  }

  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}