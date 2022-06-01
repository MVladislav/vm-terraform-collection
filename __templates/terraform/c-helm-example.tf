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
  version    = "..."

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
    value = var.kube_cert_ingress_class
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = var.kube_cert_cluster_issuer
  }
  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints"
    value = var.kube_traefik_entrypoints
  }
  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls"
    value = var.kube_traefik_tls
  }
  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = var.kube_traefik_middlewares
  }

  # # TLS (1)
  # set {
  #   name  = "ingress.tls"
  #   value = true
  # }
  # set {
  #   name  = "ingress.secretName"
  #   value = "example-template-change-me-app-name"
  # }
  # set {
  #   name  = "ingress.hostname"
  #   value = "example-host.home.local"
  # }
  # # TLS (2)
  # set {
  #   name  = "ingress.hosts[0]"
  #   value = "example-host.home.local"
  # }
  # set {
  #   name  = "ingress.tls[0].secretName"
  #   value = "example-template-change-me-app-name"
  # }
  # set {
  #   name  = "ingress.tls[0].hosts[0]"
  #   value = "example-host.home.local"
  # }

  # LOAD from values-file
  values = [
    templatefile("values/values.yaml", {

    })
  ]

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_example_template_change_me_namespace" {

  depends_on = [helm_release.example_template_change_me_namespace]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "example_template_change_me_namespace" {

  depends_on = [time_sleep.wait_for_example_template_change_me_namespace]

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
                number = 80
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
