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

          resources {
            requests = {
              cpu    = "100m"
              memory = "512M"
            }
            limits = {
              cpu    = "1000m"
              memory = "512M"
            }
          }

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

resource "time_sleep" "wait_for_example_template_change_me_namespace" {

  depends_on = [kubernetes_deployment.example_template_change_me_namespace]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "kubernetes_service" "example_template_change_me_namespace" {

  depends_on = [time_sleep.wait_for_example_template_change_me_namespace]

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

  depends_on = [kubernetes_service.example_template_change_me_namespace]

  metadata {
    name      = "example-template-change-me-app-name"
    namespace = "example-template-change-me-namespace"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = var.kube_cert_cluster_issuer
      "traefik.ingress.kubernetes.io/router.entrypoints" = var.kube_traefik_entrypoints
      "traefik.ingress.kubernetes.io/router.tls"         = var.kube_traefik_tls
      "traefik.ingress.kubernetes.io/router.middlewares" = var.kube_traefik_middlewares
    }
  }

  spec {
    ingress_class_name = var.kube_cert_ingress_class

    rule {
      host = "example-host.${var.kube_public_hostname}"

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
      hosts       = ["example-host.${var.kube_public_hostname}"]
    }
  }

}
