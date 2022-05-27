variable "cert_manager_secret_crt" {
  type      = string
  sensitive = true
}

variable "cert_manager_secret_key" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------

variable "traefik_username" {
  type      = string
  sensitive = true
}

variable "traefik_password" {
  type      = string
  sensitive = true
}
