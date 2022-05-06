resource "kubernetes_namespace" "example_template_change_me_namespace" {

  # depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "example-template-change-me-namespace"
  }

}

# ------------------------------------------------------------------------------

variable "example_template_change_me_var" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------

resource "helm_release" "example_template_change_me_namespace" {

  depends_on = [kubernetes_namespace.example_template_change_me_namespace]

  name      = "example-template-change-me-app-name"
  namespace = "example-template-change-me-namespace"

  repository = "..."
  chart      = "..."

  # DEFAULT setup
  set {
    name  = "replicaCount"
    value = 2
  }

  # INGRESS setup
  set {
    name  = "ingress.enabled"
    value = true
  }
  set {
    name  = "ingress.className"
    value = "traefik"
  }
  set {
    name  = "ingress.tls"
    value = true
  }
  set {
    name  = "ingress.secretName"
    value = "example-template-change-me-app-name"
  }
  set {
    name  = "ingress.hostname"
    value = "example-host.home.local"
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "example-template-change-me-selfsigned-cluster"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_example_template_change_me_namespace" {

  depends_on = [helm_release.example_template_change_me_namespace]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

# resource "kubernetes_ingress_v1" "example_template_change_me_namespace" {

#   depends_on = [time_sleep.wait_for_example_template_change_me_namespace]

#   metadata {
#     name      = "example-template-change-me-app-name"
#     namespace = "example-template-change-me-namespace"
#     annotations = {
#       "cert-manager.io/cluster-issuer"                      = "example-template-change-me-selfsigned-cluster"
#       "kubernetes.io/ingress.class"                         = "traefik"
#       "traefik.ingress.kubernetes.io/frontend-entry-points" = "https"
#     }
#   }

#   spec {
#     rule {
#       host = "example-host.home.local"

#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "example-template-change-me-app-name"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }

#     # (Optional) Add an SSL Certificate
#     tls {
#       secret_name = "example-template-change-me-app-name"
#       hosts       = ["example-host.home.local"]
#     }
#   }

# }
