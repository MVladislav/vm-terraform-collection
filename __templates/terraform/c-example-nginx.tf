resource "kubernetes_namespace" "<RESSOURCE_NAME>" {
  metadata {
    name = "<NAME_APP>"
  }
}

resource "kubernetes_deployment" "<RESSOURCE_NAME>" {

  depends_on = [kubernetes_namespace.<RESSOURCE_NAME>]
  metadata {
    name      = "<NAME_APP>"
    namespace = "<NAMESPACE>"

    labels = {
      app = "<NAME_APP>"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "<NAME_APP>"
      }
    }

    template {
      metadata {
        labels = {
          app = "<NAME_APP>"
        }
      }

      spec {
        container {
          name  = "<NAME_APP>"
          image = "<IMAGE>"

          port {
            name           = "http"
            container_port = <PORT>
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "<PORT>"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "<PORT>"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "<RESSOURCE_NAME>" {

  depends_on = [kubernetes_namespace.<RESSOURCE_NAME>]

  metadata {
    name      = "<NAME_APP>"
    namespace = "<NAMESPACE>"
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = "<PORT>"
      target_port = "<PORT_SERVICE>"
    }

    selector = {
      app = "<NAME_APP>"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "<RESSOURCE_NAME>" {

  depends_on = [kubernetes_namespace.<RESSOURCE_NAME>]

  metadata {
    name      = "<NAME_APP>"
    namespace = "<NAMESPACE>"
  }

  spec {
    rule {
      host = "<HOST>.home.local"

      http {
        path {
          path = "/"

          backend {
            service {
              name = "<NAME_APP>"
              port {
                number = <PORT_SERVICE>
              }
            }
          }
        }
      }
    }

    # # (Optional) Add an SSL Certificate
    # tls {
    #     secret_name = "uptime-kuma"
    #     # hosts = ["your-domain"]
    # }
  }
}
