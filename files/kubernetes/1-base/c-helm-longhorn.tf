resource "kubernetes_namespace" "longhorn" {

  # depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "longhorn"
  }

}
# ------------------------------------------------------------------------------

resource "helm_release" "longhorn" {

  depends_on = [kubernetes_namespace.longhorn]

  name      = "longhorn"
  namespace = "longhorn"

  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = var.version_longhorn

  # DEFAULT setup
  set {
    name  = "persistence.defaultClassReplicaCount"
    value = 1
  }
  set {
    name  = "persistence.reclaimPolicy"
    value = "Retain"
  }

  # INGRESS setup
  set {
    name  = "ingress.enabled"
    value = true
  }
  set {
    name  = "ingress.ingressClassName"
    value = var.kube_cert_ingress_class
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = var.kube_cert_cluster_issuer
  }
  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints"
    value = "websecure"
  }
  set {
    name  = "ingress.tls"
    value = true
  }
  set {
    name  = "ingress.tlsSecret"
    value = "longhorn"
  }
  set {
    name  = "ingress.host"
    value = "longhorn.${var.traefik_local_domain}"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_longhorn" {

  depends_on = [helm_release.longhorn]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------
