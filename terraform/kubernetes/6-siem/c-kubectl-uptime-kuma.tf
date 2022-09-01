# resource "kubernetes_namespace" "uptime_kuma" {

#   metadata {
#     name = "uptime-kuma"
#   }

# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_deployment" "uptime_kuma" {

#   depends_on = [kubernetes_namespace.uptime_kuma]

#   metadata {
#     name      = "uptime-kuma"
#     namespace = "uptime-kuma"

#     labels = {
#       app = "uptime-kuma"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "uptime-kuma"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "uptime-kuma"
#         }
#       }

#       spec {
#         container {
#           name  = "uptime-kuma"
#           image = "louislam/uptime-kuma:1.15.1"

#           port {
#             name           = "http"
#             container_port = 3001
#           }

#           liveness_probe {
#             http_get {
#               path = "/"
#               port = 3001
#             }
#           }

#           readiness_probe {
#             http_get {
#               path = "/"
#               port = 3001
#             }
#           }
#         }
#       }
#     }
#   }

# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_service" "uptime_kuma" {

#   depends_on = [kubernetes_namespace.uptime_kuma]

#   metadata {
#     name      = "uptime-kuma"
#     namespace = "uptime-kuma"
#   }

#   spec {
#     port {
#       name        = "http"
#       port        = 3001
#       target_port = 3001
#       protocol    = "TCP"
#     }

#     selector = {
#       app = "uptime-kuma"
#     }

#     type = "ClusterIP"
#   }

# }

# # ------------------------------------------------------------------------------

# resource "kubernetes_ingress_v1" "uptime_kuma" {

#   depends_on = [kubernetes_namespace.uptime_kuma]

#   metadata {
#     name      = "uptime-kuma"
#     namespace = "uptime-kuma"
#     annotations = {
#       "cert-manager.io/cluster-issuer" = var.kube_cert_cluster_issuer
#     }
#   }

#   spec {
#     ingress_class_name = var.kube_cert_ingress_class

#     rule {
#       host = "status2.home.local"

#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "uptime-kuma"
#               port {
#                 number = 3001
#               }
#             }
#           }
#         }
#       }
#     }

#     # (Optional) Add an SSL Certificate
#     tls {
#       secret_name = "uptime-kuma"
#       hosts       = ["status2.home.local"]
#     }
#   }

# }
