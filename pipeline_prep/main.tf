terraform {
  backend "gcs" {
    bucket = "terraformbackendmysqlapplication"
    prefix = "terraform/gcsstate"
  }
  required_providers {
   azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.46.0"
    }
  }
}

resource "google_service_account" "service_account" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  account_id   = "serviceconnectionsrv"
  display_name = "serviceconnectionsrv"
}

resource "google_project_iam_member" "service_account_role" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account_storage_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account_artifact_registry_migration_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "service_account_artifact_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Define a custom role for Create-on-Push functionality with push permissions
# Define a custom role with create-on-push functionality and push permissions
resource "google_project_iam_custom_role" "artifact_create_on_push_admin" {
  role_id     = "ArtifactCreateOnPushAdmin"  # Custom role ID
  title       = "Artifact Registry Create-on-Push Repository Administrator"
  description = "Custom role with permissions for Artifact Registry create-on-push functionality and push access"
  project     = "gcp-cloudrun-nodejs-mysql-app"  # Replace with your Google Cloud project ID

  permissions = [
    "artifactregistry.repositories.createOnPush",  # Permission for create-on-push functionality
    "artifactregistry.repositories.create",        # Permission to create repositories on push
    "artifactregistry.repositories.get",           # Permission to read repository details
    "artifactregistry.repositories.list",          # Permission to list repositories
    "artifactregistry.repositories.uploadArtifacts" # Permission to upload (push) artifacts to repositories
  ]
}

# Assign the custom role to the service account
resource "google_project_iam_member" "artifact_create_on_push_member" {
  project = "gcp-cloudrun-nodejs-mysql-app"  # Replace with your Google Cloud project ID
  role    = google_project_iam_custom_role.artifact_create_on_push_admin.name
  member  = "serviceAccount:${google_service_account.service_account.email}"  # Replace with your service account
}

resource "google_project_iam_member" "cloud_run_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"  # Replace with your Google Cloud project ID
  role    = "roles/run.admin"  # Cloud Run Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"  # Service account
}

resource "google_project_iam_member" "cloud_run_developer" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/run.developer"  # Cloud Run Developer role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloud_run_source_developer" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/run.sourceDeveloper"  # Cloud Run Source Developer role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloud_sql_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/cloudsql.admin"  # Cloud SQL Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloud_sql_editor" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/cloudsql.editor"  # Cloud SQL Editor role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "compute_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/compute.admin"  # Compute Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "compute_network_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/compute.networkAdmin"  # Compute Network Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "create_service_accounts" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/iam.serviceAccountCreator"  # Create Service Accounts role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "secret_manager_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/secretmanager.admin"  # Secret Manager Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "secret_manager_secret_accessor" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/secretmanager.secretAccessor"  # Secret Manager Secret Accessor role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "secret_manager_secret_version_manager" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/secretmanager.secretVersionManager"  # Secret Manager Secret Version Manager role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/iam.serviceAccountAdmin"  # Service Account Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account_token_creator" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/iam.serviceAccountTokenCreator"  # Service Account Token Creator role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/iam.serviceAccountUser"  # Service Account User role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_networking_service_agent" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/servicenetworking.serviceAgent"  # Service Networking Service Agent role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "storage_object_admin" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/storage.objectAdmin"  # Storage Object Admin role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "storage_object_creator" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/storage.objectCreator"  # Storage Object Creator role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "storage_object_viewer" {
  project = "gcp-cloudrun-nodejs-mysql-app"
  role    = "roles/storage.objectViewer"  # Storage Object Viewer role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}



# Generate service account key



resource "google_service_account_key" "keys" {
  service_account_id = google_service_account.service_account.id
}

output "keyoutput" {
  value = google_service_account_key.keys
  sensitive = true
}

output "privatekey" {
  value = base64decode(google_service_account_key.keys.private_key)
  sensitive = true
}


# Azure DevOps Docker Registry Service Connection
resource "azuredevops_serviceendpoint_dockerregistry" "example-other" {
  project_id            = "e69347fe-866a-4751-9eba-a2e02df90481"
  service_endpoint_name = "docker_registery_connection"
  docker_registry       = "https://gcr.io/gcp-cloudrun-nodejs-mysql-app"
  docker_username       = "_json_key"
  docker_password       =  base64decode(google_service_account_key.keys.private_key) #""#file("./service_account_key.json")  #google_service_account_key.keys.private_key  # Pass the content of the JSON key as password
  registry_type         = "Others"
}

module "container_registry" {
  source   = "./modules/Container_Registry"
  for_each = { for i in var.registry_config : i.repository_id => i }
  project  = each.value["project"]
  # location = each.value["location"]
  location      = each.value["location"]
  repository_id = each.value["repository_id"]
  description   = each.value["description"]
  format        = each.value["format"]
}



/* # Azure DevOps GCP Terraform Service Endpoint
resource "azuredevops_serviceendpoint_gcp_terraform" "example" {
  project_id            = "e69347fe-866a-4751-9eba-a2e02df90481"
  token_uri             = "https://oauth2.googleapis.com/token"
  client_email          = google_service_account.service_account.email
  private_key           = google_service_account_key.keys.private_key  # Pass the content of the JSON key as private key
  service_endpoint_name = "gcp_service_connection"
  gcp_project_id        = "gcp-cloudrun-nodejs-mysql-app"
  description           = "Managed by Terraform"
} */
