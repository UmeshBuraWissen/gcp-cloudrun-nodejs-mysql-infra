project_config = [
  {
    name           = "gcp-cloudrun-nodejs-mysql-app"
    project_id     = "gcp-cloudrun-nodejs-mysql-app"
    org_id         = "501043380274"
    enable_network = false
  }
]
VPC_config = [
  {
    name                            = "wissen-nodejs-app-gcp-vpc"
    auto_create_subnetworks         = "false"
    routing_mode                    = "GLOBAL"
    project                         = "gcp-cloudrun-nodejs-mysql-app"
    description                     = "new vpc"
    delete_default_routes_on_create = "false"
    mtu                             = 0
    subnet_name                     = "wissen-nodejs-app-gcp-subnetwork"
    ip_cidr_range                   = "10.2.0.0/16"
    region                          = "us-central1"
    network                         = "wissen-nodejs-app-gcp-vpc"
    secondary_ip_range = [{
      range_name    = "tf-wissen-nodejs-app-gcp-secondary-range-update1"
      ip_cidr_range = "192.168.64.0/24"
    }]
    allow = {
      protocol = "tcp"
      ports    = ["80"]
    }
    source_ranges = ["0.0.0.0/0"]
    direction     = "INGRESS"
    target_tags   = ["http-server"]

}]
# svc_config = [{
#   project      = "gcp-cloudrun-nodejs-mysql-app"
#   account_id   = "nodejs-app-gcp-service-account"
#   display_name = "wissen nodejs app gcp Service Account"
#   description  = "This is a service account created by Terraform."
#   role = ["roles/iam.serviceAccountUser" , "roles/iam.serviceAccounts.setIamPolicy"]
# }]
registry_config = [
  {
    project = "gcp-cloudrun-nodejs-mysql-app"
    # location = "US"
    location      = "us-central1"
    repository_id = "wissen-nodejs-app-gcp-repository"
    description   = "example docker repository"
    format        = "DOCKER"
  }
]
cloudrunsql_config = [
  {
    name       = "wissen-nodejs-app-gcp-cloudrun-mysql"
    location   = "us-central1"
    project_id = "gcp-cloudrun-nodejs-mysql-app"
    image      = "gcr.io/gcp-cloudrun-nodejs-mysql-app/nodejsapp:latest"
    maxScale   = "10"
    sql_name   = "wissen-nodejs-app-gcp-mysql"
    client-name                = "terraform"
    autogenerate_revision_name = true
    timeout_seconds            = 6000
    service_account_name       = "nodejsdemo@gcp-cloudrun-nodejs-mysql-app.iam.gserviceaccount.com"
    envs = {
      "port"             = "3000"
      "projectid"        = "277275469326"
      "dbconnectionname" = "gcp-cloudrun-nodejs-mysql-app:us-central1:wissen-nodejs-app-gcp-mysql"

    }

  }
]
sql_config = [
  {
    location            = "us-central1"
    project_id          = "gcp-cloudrun-nodejs-mysql-app"
    sql_name            = "wissen-nodejs-app-gcp-mysql"
    # database_version    = "MYSQL_8_0"
    
    deletion_protection = false
    sql_user_name       = "nodejsuser"
    sql_user_pass       = "Wissen12345"
  private-network-name                    = "private-network"
  auto_create_subnetworks = false
    private-ip-address-name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  service                 = "servicenetworking.googleapis.com"
  firewall_name    = "deny-all-ingress"
  protocol = "all"
    direction = "INGRESS"
  priority  = 1000  
  source_ranges = ["0.0.0.0/0"]
  # settings = {
  #   tier                = "db-f1-micro"
  # backup_configuration = {
  #       enabled            = true
  #     binary_log_enabled = true
  # }
  # ip_configuration = {
  #     ipv4_enabled    = false
  #           ssl_mode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
  #     require_ssl = true
  # }
  # }
        import_custom_routes = true
  export_custom_routes = true
  
  
  }
]
secret_config = [{
  secret_id = "secret"
  project   = "gcp-cloudrun-nodejs-mysql-app"
  label     = "my-label"
  location  = "us-east1"
}]


vpc_connector_config = [
  {
  project_id    =  "gcp-cloudrun-nodejs-mysql-app"
  region        = "us-east1"
  name          = "wissen-nodejs-app-gcp-vpc-connector"
  network       = "wissen-nodejs-app-gcp-vpc" #module.vpc.network_name
  ip_cidr_range = "10.8.0.0/28"
  }
]

domainmapping_config = [
  {
    project_id    =  "gcp-cloudrun-nodejs-mysql-app"
    location  = "us-east1"
    name = "www.wissencloudrun.com"
    route_name = "wissen-nodejs-app-gcp-cloudrun-mysql"
    metadata_namespace = "gcp-cloudrun-nodejs-mysql-app"
  }
]