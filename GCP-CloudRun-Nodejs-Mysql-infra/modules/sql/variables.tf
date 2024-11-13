variable "sql_name" {
  type = string
}

# variable "settings" {
#   type = object({
#     tier = string
#   })
# }
variable "deletion_protection" {
  type = bool
}
variable "location" {
  type = string
}
variable "project_id" {

}
variable "sql_user_name" {
  type        = string
  description = "Username of SQL database"
}

variable "sql_user_pass" {
  type        = string
  description = "Login password of SQL database"
}

# variable "database_version" {
#   type = string 
# }
variable "private-network-name" {
    type        = string
  description = "private-network-name"
}
variable "auto_create_subnetworks" {
  type = bool
}
variable "private-ip-address-name" {
  type = string
  description = "private-ip-address-name"
}
variable "purpose" {
  type = string
}
variable "address_type" {
  type = string
}
variable "prefix_length" {
  type = number
}
variable "service" {
  type = string
}
variable "firewall_name" {
  type = string
}
variable "protocol" {
  type = string
}
variable "direction" {
  type = string
}
variable "priority" {
  type = number
}
variable "source_ranges" {
  type = list(string)
}
# variable "enabled" {
#   type = bool
# }
# variable "binary_log_enabled" {
#   type = bool
# }
# variable "ipv4_enabled" {
#   type = bool
# }
# variable "ssl_mode" {
#   type = string
# }
# variable "require_ssl" {
#   type = bool
# }
variable "import_custom_routes" {
  type = bool
}
variable "export_custom_routes" {
  type = bool
}
# variable "backup_configuration" {
#   type = object({
#     enabled = bool
#     binary_log_enabled = bool
#   })
# }

# variable "settings" {
#   type = object({
#     tier = string
#     backup_configuration = object({
#             enabled            = bool
#       binary_log_enabled = bool
#     })
#         ip_configuration = object({
#                 ipv4_enabled    = bool
#       ssl_mode = string
#       require_ssl = bool
#         })


#   })
# }

  