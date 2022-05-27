resource "kubernetes_namespace" "traefik" {

  depends_on = [time_sleep.wait_for_clusterissuer]

  metadata {
    name = "traefik"
  }

}

resource "kubectl_manifest" "traefik_certificate_default" {

  depends_on = [kubernetes_namespace.traefik]

  yaml_body = <<YAML
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: traefik-certificate-default
  namespace: traefik
spec:
  secretName: traefik-certificate-default
  dnsNames:
    - home.local
    - "*.home.local"
  wildcard: true
  issuerRef:
    kind: ClusterIssuer
    name: ${var.kube_cert_cluster_issuer}
YAML

}

# ------------------------------------------------------------------------------

resource "helm_release" "traefik" {

  depends_on = [
    kubernetes_namespace.traefik,
    kubernetes_config_map_v1.traefik_config,
    kubectl_manifest.traefik_certificate_default
  ]

  name      = "traefik"
  namespace = "traefik"

  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.19.5"

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

# ------------------------------------------------------------------------------

resource "kubernetes_secret_v1" "traefik_dashboard_credentials" {

  depends_on = [time_sleep.traefik]

  metadata {
    name      = "traefik-dashboard-credentials"
    namespace = "traefik"
  }

  data = {
    username = var.traefik_username
    password = var.traefik_password
  }

  type = "kubernetes.io/basic-auth"
}


resource "kubernetes_manifest" "traefik_dashboard_middleware_auth" {

  depends_on = [kubernetes_secret_v1.traefik_dashboard_credentials]

  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "traefik-dashboard-auth"
      "namespace" = "traefik"
    }
    "spec" = {
      "basicAuth" = {
        "secret" = "traefik-dashboard-credentials"
      }
    }
  }
}

resource "kubectl_manifest" "traefik_dashboard_certificate" {

  depends_on = [time_sleep.traefik]

  yaml_body = <<YAML
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: traefik-dashboard-cert
  namespace: traefik
spec:
  secretName: traefik-dashboard-cert
  dnsNames:
    - traefik.home.local
  issuerRef:
    kind: ClusterIssuer
    name: ${var.kube_cert_cluster_issuer}
YAML

}

resource "kubernetes_manifest" "traefik_dashboard_ingressroute" {

  depends_on = [
    kubernetes_manifest.traefik_dashboard_middleware_auth,
    kubectl_manifest.traefik_dashboard_certificate
  ]

  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "traefik-dashboard-public"
      "namespace" = "traefik"
    }
    "spec" = {
      "entryPoints" = [
        "web",
        "websecure",
      ]
      "routes" = [
        {
          "kind"  = "Rule"
          "match" = "Host(`traefik.home.local`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))"
          "middlewares" = [
            {
              "name" = "traefik-dashboard-auth"
            },
          ]
          "services" = [
            {
              "kind" = "TraefikService"
              "name" = "api@internal"
            },
          ]
        },
      ]
      "tls" = {
        "secretName" = "traefik-dashboard-cert"
      }
    }
  }
}
