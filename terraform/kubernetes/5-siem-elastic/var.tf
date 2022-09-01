# ------------------------------------------------------------------------------

variable "elastic_cred_elasticsearch_password" {
  type      = string
  sensitive = true
}
variable "elastic_cred_kibana_password" {
  type      = string
  sensitive = true
}
variable "elastic_cred_kibana_secret_key" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------

variable "elastic_public_domain_elasticsearch" {
  type    = string
  default = "elastic2"
}
variable "elastic_public_domain_kibana" {
  type    = string
  default = "kibana2"
}
