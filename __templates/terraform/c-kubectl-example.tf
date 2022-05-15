resource "kubernetes_namespace" "example_template_change_me_namespace" {

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

resource "kubernetes_deployment" "example_template_change_me_namespace" {

  depends_on = [kubernetes_namespace.example_template_change_me_namespace]

  metadata {
    name      = "example-template-change-me-app-name"
    namespace = "example-template-change-me-namespace"

    labels = {
      app = "example-template-change-me-app-name"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "example-template-change-me-app-name"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-template-change-me-app-name"
        }
      }

      spec {
        container {
          name  = "example-template-change-me-app-name"
          image = ".../...:latest"

          port {
            name           = "http"
            container_port = 3001
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3001
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 3001
            }
          }
        }
      }
    }
  }

}

# ------------------------------------------------------------------------------

resource "kubernetes_service" "example_template_change_me_namespace" {

  depends_on = [kubernetes_namespace.example_template_change_me_namespace]

  metadata {
    name      = "example-template-change-me-app-name"
    namespace = "example-template-change-me-namespace"
  }

  spec {
    port {
      name        = "http"
      port        = 3001
      target_port = 3001
      protocol    = "TCP"
    }

    selector = {
      app = "example-template-change-me-app-name"
    }

    type = "ClusterIP"
  }

}

# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "example_template_change_me_namespace" {

  depends_on = [kubernetes_namespace.example_template_change_me_namespace]

  metadata {
    name      = "example-template-change-me-app-name"
    namespace = "example-template-change-me-namespace"
    annotations = {
      "cert-manager.io/cluster-issuer"                      = "example-template-change-me-selfsigned-cluster"
      "kubernetes.io/ingress.class"                         = "traefik"
      "traefik.ingress.kubernetes.io/frontend-entry-points" = "https"
    }
  }

  spec {
    rule {
      host = "example-host.home.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "example-template-change-me-app-name"
              port {
                number = 3001
              }
            }
          }
        }
      }
    }

    # (Optional) Add an SSL Certificate
    tls {
      secret_name = "example-template-change-me-app-name"
      hosts       = ["example-host.home.local"]
    }
  }

}
