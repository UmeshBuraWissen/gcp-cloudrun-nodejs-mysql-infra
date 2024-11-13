variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "project_id" {
  
}
variable "envs" {
  type = map(string)
}
variable "template" {
  type = object({
    spec = object({
      containers = object({
        image = string
      })
    })
  })
}
variable "metadata" {
  type = object({
    annotations = object({
      maxScale = string
      connection_name = string
      client-name = string
    })
  })
}
variable "autogenerate_revision_name" {
  type = bool
}
variable "timeout_seconds" {
  
}
variable "service_account_name" {
  
}
