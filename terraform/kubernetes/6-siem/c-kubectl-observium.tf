# resource "kubernetes_namespace" "observium" {

#   metadata {
#     name = "observium"
#   }

# }

# # ------------------------------------------------------------------------------

# variable "tz" {
#   type = string
# }
# variable "observium_admin_user" {
#   type      = string
#   sensitive = true
# }
# variable "observium_admin_pass" {
#   type      = string
#   sensitive = true
# }
# variable "observium_db_host" {
#   type      = string
#   sensitive = true
# }
# variable "observium_db_name" {
#   type      = string
#   sensitive = true
# }
# variable "observium_db_user" {
#   type      = string
#   sensitive = true
# }
# variable "observium_db_pass" {
#   type      = string
#   sensitive = true
# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_deployment" "observium" {

#   depends_on = [kubernetes_namespace.observium]

#   metadata {
#     name      = "observium"
#     namespace = "observium"

#     labels = {
#       app = "observium"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "observium"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "observium"
#         }
#       }

#       spec {
#         container {
#           name  = "observium"
#           image = "mbixtech/observium:21.10"

#           env {
#             name  = ""
#             value = ""
#           }

#           env {
#             name  = "TZ"
#             value = var.tz
#           }
#           env {
#             name  = "OBSERVIUM_ADMIN_USER"
#             value = var.observium_admin_user
#           }
#           env {
#             name  = "OBSERVIUM_ADMIN_PASS"
#             value = var.observium_admin_pass
#           }
#           env {
#             name  = "OBSERVIUM_DB_HOST"
#             value = var.observium_db_host
#           }
#           env {
#             name  = "OBSERVIUM_DB_NAME"
#             value = var.observium_db_name
#           }
#           env {
#             name  = "OBSERVIUM_DB_USER"
#             value = var.observium_db_user
#           }
#           env {
#             name  = "OBSERVIUM_DB_PASS"
#             value = var.observium_db_pass
#           }

#           port {
#             name           = "http"
#             container_port = 80
#           }

#           liveness_probe {
#             http_get {
#               path = "/"
#               port = 80
#             }
#           }

#           readiness_probe {
#             http_get {
#               path = "/"
#               port = 80
#             }
#           }
#         }
#       }
#     }
#   }

# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_service" "observium" {

#   depends_on = [kubernetes_namespace.observium]

#   metadata {
#     name      = "observium"
#     namespace = "observium"
#   }

#   spec {
#     port {
#       name        = "http"
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }

#     selector = {
#       app = "observium"
#     }

#     type = "ClusterIP"
#   }

# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_ingress_v1" "observium" {

#   depends_on = [kubernetes_namespace.observium]

#   metadata {
#     name      = "observium"
#     namespace = "observium"
#     annotations = {
#       "cert-manager.io/cluster-issuer" = var.kube_cert_cluster_issuer
#     }
#   }

#   spec {
#     ingress_class_name = var.kube_cert_ingress_class

#     rule {
#       host = "observium2.home.local"

#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "observium"
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
#       secret_name = "observium"
#       hosts       = ["observium2.home.local"]
#     }
#   }

# }
