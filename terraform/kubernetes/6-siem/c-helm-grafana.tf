# resource "kubernetes_namespace" "grafana" {

#   # depends_on = [time_sleep.wait_for_kubernetes]

#   metadata {
#     name = "grafana"
#   }

# }

# # ------------------------------------------------------------------------------

# variable "example_template_change_me_var" {
#   type      = string
#   sensitive = true
# }

# # ------------------------------------------------------------------------------

# resource "helm_release" "grafana" {

#   depends_on = [kubernetes_namespace.grafana]

#   name      = "grafana"
#   namespace = "grafana"

#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   version    = "6.29.4"

#   # DEFAULT setup
#   set {
#     name  = "replicas"
#     value = 1
#   }

#   # INGRESS setup
#   set {
#     name  = "ingress.enabled"
#     value = true
#   }
#   set {
#     name  = "ingress.className"
#     value = var.kube_cert_ingress_class
#   }
#   set {
#     name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
#     value = var.kube_cert_cluster_issuer
#   }
#   set {
#     name  = "ingress.hosts[0]"
#     value = "grafana.home.local"
#   }
#   set {
#     name  = "ingress.tls[0].secretName"
#     value = "grafana"
#   }
#   set {
#     name  = "ingress.tls[0].hosts[0]"
#     value = "grafana.home.local"
#   }

# }

# # ------------------------------------------------------------------------------

# resource "time_sleep" "wait_for_grafana" {

#   depends_on = [helm_release.grafana]

#   create_duration = "30s"

# }

# # ------------------------------------------------------------------------------
