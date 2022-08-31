
# VERSIONS
# ------------------------------------------------------------------------------

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

variable "traefik_local_domain" {
  type    = string
  default = "home.local"
}
