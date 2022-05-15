resource "kubernetes_namespace" "kubernetes_dashboard" {

  # depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "kubernetes-dashboard"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "kubernetes_dashboard" {

  depends_on = [kubernetes_namespace.kubernetes_dashboard]

  name      = "kubernetes-dashboard"
  namespace = "kubernetes-dashboard"

  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"

  set {
    name  = "replicaCount"
    value = 1
  }

  # set {
  #   name  = "service.type"
  #   value = "LoadBalancer"
  # }

  set {
    name  = "protocolHttp"
    value = "true"
  }
  set {
    name  = "service.externalPort"
    value = 80
  }

  set {
    name  = "rbac.clusterReadOnlyRole"
    value = "true"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_kubernetes_dashboard" {

  depends_on = [helm_release.kubernetes_dashboard]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "kubernetes_dashboard" {

  depends_on = [time_sleep.wait_for_kubernetes_dashboard]

  metadata {
    name      = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    annotations = {
      "cert-manager.io/cluster-issuer"                      = "cert-manager-selfsigned-cluster"
      "kubernetes.io/ingress.class"                         = "traefik"
      "traefik.ingress.kubernetes.io/frontend-entry-points" = "https"
    }
  }

  spec {
    rule {
      host = "k3s.home.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kubernetes-dashboard"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    # (Optional) Add an SSL Certificate
    tls {
      secret_name = "kubernetes-dashboard"
      hosts       = ["k3s.home.local"]
    }
  }

}
