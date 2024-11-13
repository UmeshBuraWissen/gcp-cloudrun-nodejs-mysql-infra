resource "google_kms_key_ring" "keyring" {
  project  = var.project
  name     = "test-keyring"
  location = "global"
}

resource "google_kms_crypto_key" "example-key" {
  name            = "test-crypto-key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}
resource "google_artifact_registry_repository" "my-repo" {
  project  = var.project
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  kms_key_name = google_kms_crypto_key.example-key.id
}