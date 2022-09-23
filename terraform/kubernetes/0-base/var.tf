
# VERSIONS
# ------------------------------------------------------------------------------

# https://artifacthub.io/packages/helm/cert-manager/cert-manager
variable "version_cert_manager" {
  type    = string
  default = "1.9.1"
}

# https://artifacthub.io/packages/helm/traefik/traefik
variable "version_traefik" {
  type    = string
  default = "10.24.1"
}

# https://artifacthub.io/packages/helm/argo/argo-cd
variable "version_argo_cd" {
  type    = string
  default = "5.4.0"
}

# ------------------------------------------------------------------------------

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
