resource "google_cloud_run_service" "default" {
  name     = var.name
  location = var.location
    project      = var.project_id
  template {
    spec {
      containers {
        image = var.template.spec.containers.image
        dynamic "env" {
   for_each = var.envs
   content {     
    name  = env.key
     value = env.value
   }
   
}
         ports {
          container_port = 3000  
        }
      }
    }

    metadata {
      annotations = {
        
        "autoscaling.knative.dev/maxScale"      = var.metadata.annotations.maxScale
        "run.googleapis.com/cloudsql-instances" = var.metadata.annotations.connection_name
        "run.googleapis.com/client-name"        = var.metadata.annotations.client-name
        # "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.name
        timeout_seconds = var.timeout_seconds
        service_account_name = var.service_account_name
      }
    }
    
  }
  
  autogenerate_revision_name = var.autogenerate_revision_name
  
}
data "google_iam_policy" "noauth" {

  binding {
    role    = "roles/run.invoker"
    members = ["allUsers",]
  }
}
resource "google_cloud_run_service_iam_policy" "noauth" {
  service     = google_cloud_run_service.default.name
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  policy_data = data.google_iam_policy.noauth.policy_data
  depends_on = [ google_cloud_run_service.default ]
}

