
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

# https://artifacthub.io/packages/helm/longhorn/longhorn
variable "version_longhorn" {
  type    = string
  default = "1.3.1"
}

# https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard
variable "version_kubernetes_dashboard" {
  type    = string
  default = "5.10.0"
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


variable "traefik_local_domain" {
  type    = string
  default = "home.local"
}

variable "traefik_username" {
  type      = string
  sensitive = true
}

variable "traefik_password" {
  type      = string
  sensitive = true
}
