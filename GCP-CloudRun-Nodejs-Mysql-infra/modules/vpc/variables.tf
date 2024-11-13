variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "routing_mode" {
  type        = string

}

# variable "shared_vpc_host" {
#   type        = bool

# }

variable "description" {
  type        = string

}

variable "auto_create_subnetworks" {
  type        = bool


}

variable "delete_default_internet_gateway_routes" {
  type        = bool
 
}

variable "mtu" {
  type        = number
  
}
#subnet
variable "subnet_name" {
    type = string
}
variable "ip_cidr_range" {
    type = string
  
}
variable "region" {
type = string
}
# variable "network" {
#     type = string
  
# }
variable "secondary_ip_range" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
}
#Firewall

variable "firewall_name" {
  description = "The name of the firewall rule"
  type        = string
}
variable "source_ranges" {
  description = "The source ranges for the firewall rule"
  type        = list(string)
}

variable "direction" {
  description = "The direction of the firewall rule"
  type        = string
}

variable "target_tags" {
  description = "The target tags for the firewall rule"
  type        = list(string)
}
variable "allow" {
    type = object({
      protocol = string
      ports = set(string)
    })
  
}

