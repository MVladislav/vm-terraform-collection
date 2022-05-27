resource "kubernetes_namespace" "kubernetes_dashboard" {

  depends_on = [time_sleep.traefik]

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
  version    = "5.4.1"

  # DEFAULT setup
  set {
    name  = "replicaCount"
    value = 1
  }

  # DASH setup
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
    name  = "traefik.ingress.kubernetes\\.io/router.entrypoints"
    value = "websecure"
  }
  set {
    name  = "ingress.hosts[0]"
    value = "k3s.home.local"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "kubernetes-dashboard"
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "k3s.home.local"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_kubernetes_dashboard" {

  depends_on = [helm_release.kubernetes_dashboard]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------
