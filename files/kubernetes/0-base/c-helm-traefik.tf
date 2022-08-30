resource "kubernetes_namespace" "traefik" {

  depends_on = [time_sleep.wait_for_clusterissuer]

  metadata {
    name = "traefik"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "traefik" {

  depends_on = [
    kubernetes_namespace.traefik,
    kubernetes_config_map_v1.traefik_config
  ]

  name      = "traefik"
  namespace = "traefik"

  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = var.version_traefik

  # DEFAULT setup
  set {
    name  = "deployment.replicas"
    value = 1
  }

  # set traefik as default ingress controller
  set {
    name  = "ingressClass.enabled"
    value = "true"
  }
  set {
    name  = "ingressClass.isDefaultClass"
    value = "true"
  }

  # set {
  #   name  = "traefik.ingress.kubernetes\\.io/router.tls.options"
  #   value = "cert-manager-selfsigned-cluster@kubernetescrd"
  # }

  # LOAD from values-file
  values = [
    templatefile("values/traefik.yaml", {
      "kube_cert_cluster_issuer"     = var.kube_cert_cluster_issuer
      "traefik_elastic_server_url"   = "http://apm-server:8200"
      "traefik_elastic_secret_token" = ""
    })
  ]

}

# ------------------------------------------------------------------------------

resource "time_sleep" "traefik" {

  depends_on = [helm_release.traefik]

  create_duration = "30s"

}
