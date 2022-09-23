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
    # kubernetes_config_map_v1.traefik_config
  ]

  name      = "traefik"
  namespace = "traefik"

  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = var.version_traefik

  # DEFAULT setup
  set {
    name  = "deployment.replicas"
    value = 2
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

  # Default Redirect
  set {
    name  = "ports.web.redirectTo"
    value = "websecure"
  }

  # Enable TLS on Websecure
  set {
    name  = "ports.websecure.tls.enabled"
    value = "true"
  }

  # TLS Options (that's not working for some reason...)
  set {
    name  = "tlsOptions.default.minVersion"
    value = "VersionTLS12"
  }

  # set {
  #   name  = "traefik.ingress.kubernetes\\.io/router.tls.options"
  #   value = "cert-manager-selfsigned-cluster@kubernetescrd"
  # }

  # LOAD from values-file
  values = [
    templatefile("values/traefik.yaml", {
    })
  ]

}

# ------------------------------------------------------------------------------

resource "time_sleep" "traefik" {

  depends_on = [helm_release.traefik]

  create_duration = "30s"

}
