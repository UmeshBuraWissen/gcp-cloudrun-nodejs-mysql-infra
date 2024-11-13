resource "google_kms_key_ring" "keyring" {
  project  = var.project
  name     = "gcp-cloudrun-sql-nodeapp-keyring"
  location = var.location
}

resource "google_kms_crypto_key" "example-key" {
  name            = "gcp-cloudrun-sql-nodeapp-keyring-crypto-key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}

/* # Grant Artifact Registry service account access to KMS key
resource "google_kms_crypto_key_iam_member" "artifact_registry_key_access" {
  crypto_key_id = google_kms_crypto_key.example-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}
 */
/* resource "google_artifact_registry_repository" "my-repo" {
  project  = var.project
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  kms_key_name = google_kms_crypto_key.example-key.id
} */