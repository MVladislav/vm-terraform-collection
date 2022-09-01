resource "kubernetes_namespace" "argo_cd" {

  depends_on = [time_sleep.traefik]

  metadata {
    name = "argo-cd"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "argo_cd" {

  depends_on = [kubernetes_namespace.argo_cd]

  name      = "argo-cd"
  namespace = "argo-cd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.version_argo_cd

  # # DEFAULT setup
  # set {
  #   name  = "replicaCount"
  #   value = 2
  # }

  # INGRESS setup
  set {
    name  = "server.ingress.enabled"
    value = true
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = var.kube_cert_ingress_class
  }
  set {
    name  = "server.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = var.kube_cert_cluster_issuer
  }
  set {
    name  = "server.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints"
    value = var.kube_traefik_entrypoints
  }
  set {
    name  = "server.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls"
    value = var.kube_traefik_tls
  }
  set {
    name  = "server.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = var.kube_traefik_middlewares
  }

  # TLS
  set {
    name  = "server.ingress.hosts[0]"
    value = "argo.${var.kube_public_hostname}"
  }
  set {
    name  = "server.ingress.tls[0].secretName"
    value = "argo-cd"
  }
  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = "argo.${var.kube_public_hostname}"
  }

  # disable interl TLS, because of TLS redirect looping
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  # LOAD from values-file
  values = [
    templatefile("values/argo-cd.yaml", {

    })
  ]

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_argo_cd" {

  depends_on = [helm_release.argo_cd]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------
