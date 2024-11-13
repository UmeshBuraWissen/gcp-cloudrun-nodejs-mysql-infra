module "project" {
  source         = "./modules/Project"
  for_each       = { for i in var.project_config : i.project_id => i }
  name           = each.value["name"]
  project_id     = each.value["project_id"]
  org_id         = each.value["org_id"]
  enable_network = each.value["enable_network"]
}

module "vpc" {
  source                                 = "./modules/vpc"
  for_each                               = { for i in var.VPC_config : i.name => i }
  network_name                           = each.value["name"]
  auto_create_subnetworks                = each.value["auto_create_subnetworks"]
  routing_mode                           = each.value["routing_mode"]
  project_id                             = each.value["project"]
  description                            = each.value["description"]
  delete_default_internet_gateway_routes = each.value["delete_default_routes_on_create"]
  mtu                                    = each.value["mtu"]
  subnet_name                            = each.value["name"]
  ip_cidr_range                          = each.value["ip_cidr_range"]
  region                                 = each.value["region"]
  secondary_ip_range                     = each.value.secondary_ip_range

  firewall_name = each.value["name"]
  allow = {
    protocol = each.value.allow["protocol"]
    ports    = each.value.allow["ports"]
  }
  source_ranges = each.value["source_ranges"]
  direction     = each.value["direction"]
  target_tags   = each.value["target_tags"]
}


# module "svc" {
#   source       = "./modules/service-account"
#   for_each     = { for i in var.svc_config : i.account_id => i }
#   project_id   = each.value["project"]
#   account_id   = each.value["account_id"]
#   display_name = each.value["display_name"]
#   description  = each.value["description"]
#   role         = each.value["role"]
#   # members = each.value["service_account_id"]
# }

#contianer registery
/* module "container_registry" {
  source   = "./modules/Container_Registry"
  for_each = { for i in var.registry_config : i.repository_id => i }
  project  = each.value["project"]
  # location = each.value["location"]
  location      = each.value["location"]
  repository_id = each.value["repository_id"]
  description   = each.value["description"]
  format        = each.value["format"]
} */
module "cloudRun" {
  source     = "./modules/cloudrun"
  for_each   = { for i in var.cloudrunsql_config : i.name => i }
  name       = each.value["name"]
  location   = each.value["location"]
  project_id = each.value["project_id"]
  envs       = each.value["envs"]
  template = {
    spec = {
      containers = {
        image = each.value["image"]
      }
    }
  }
  metadata = {
    annotations = {
      maxScale        = each.value["maxScale"]
      connection_name = module.cloudSql[each.value["sql_name"]].connection_name
      client-name     = each.value["client-name"]
    }
  }
  autogenerate_revision_name = each.value["autogenerate_revision_name"]
  timeout_seconds            = each.value["timeout_seconds"]
  service_account_name       = each.value["service_account_name"]
depends_on = [ module.cloudSql ]

}
module "cloudSql" {
  source           = "./modules/sql"
  for_each         = { for i in var.sql_config : i.sql_name => i }
  location         = each.value["location"]
  project_id       = each.value["project_id"]
  sql_name         = each.value["sql_name"]
  # database_version = each.value["database_version"]
  # settings = {
  #    tier = each.value.settings["tier"]
  #   backup_configuration = {
  #     enabled            = each.value.settings.backup_configuration["enabled"]
  #     binary_log_enabled = veach.value.settings.backup_configuration["binary_log_enabled"]

  #   }
    
  #   ip_configuration = {
  #     ipv4_enabled    = each.value.settings.ip_configuration["ipv4_enabled"]
  #     private_network = each.value.settings.ip_configuration["private_network"]
  #     ssl_mode = each.value.settings.ip_configuration["ssl_mode"]
  #     require_ssl = each.value.settings.ip_configuration["require_ssl"]
  #   }


  # }
  deletion_protection = each.value["deletion_protection"]
  sql_user_name       = each.value["sql_user_name"]
  sql_user_pass       = each.value["sql_user_pass"]
    private-network-name                    = each.value["private-network-name"]
  auto_create_subnetworks = each.value["auto_create_subnetworks"]
  private-ip-address-name = each.value["private-ip-address-name"]
  purpose = each.value["purpose"]
  address_type = each.value["address_type"]
  prefix_length = each.value["prefix_length"]
   service = each.value["service"]
   firewall_name = each.value["firewall_name"]
   protocol = each.value["protocol"]
     direction = each.value["direction"]
  priority  = each.value["priority"]
  source_ranges = each.value["source_ranges"]

  # backup_configuration = {
  #       enabled            = each.value.backup_configuration["enabled"]
  #     binary_log_enabled = each.value.backup_configuration["binary_log_enabled"]
  # }
  #     ipv4_enabled = each.value["ipv4_enabled"]
      #       ssl_mode = each.value["ssl_mode"]
      # require_ssl = each.value["require_ssl"]
        import_custom_routes = each.value["import_custom_routes"]
  export_custom_routes = each.value["export_custom_routes"]
}

module "secret-manager" {
  source    = "./modules/secret-manager"
  for_each  = { for i in var.secret_config : i.secret_id => i }
  secret_id = each.value["secret_id"]
  project   = each.value["project"]
  label     = each.value["label"]
  location  = each.value["location"]
}

/* module "serverless_vpc_access" {
  source = "./modules/vpc_connector"
  for_each = { for i in var.vpc_connector_config : i.name => i }
  project_id    =  each.value["project_id"]
  region        = each.value["region"]
  name          = each.value["name"] #"serverless-access"
  network       = each.value["network"] #module.vpc.network_name
  ip_cidr_range = each.value["ip_cidr_range"] #"10.132.0.0/28"
} */


/* module "domainmapping" {
  source = "./modules/domainmapping"
  for_each = { for i in var.domainmapping_config : i.name => i }
  project_id    =  each.value["project_id"]
  name          = each.value["name"] #"serverless-access"
  location = each.value["location"]
  route_name = each.value["route_name"]
  metadata_namespace = each.value["metadata_namespace"]
} */