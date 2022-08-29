# ------------------------------------------------------------------------------

variable "mysql_credentials_root_password" {
  type      = string
  sensitive = true
}
variable "mysql_credentials_replication_password" {
  type      = string
  sensitive = true
}
variable "mysql_credentials_password" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------
