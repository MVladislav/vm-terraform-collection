
resource "kubernetes_manifest" "traefik_middleware_header_default" {

  depends_on = [time_sleep.traefik]

  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "traefik-middleware-header-default"
      "namespace" = "traefik"
    }
    "spec" = {
      "headers" = {
        "frameDeny"               = "true"
        "browserXssFilter"        = "true"
        "contentTypeNosniff"      = "true"
        "forceSTSHeader"          = "true"
        "stsIncludeSubdomains"    = "true"
        "stsPreload"              = "true"
        "stsSeconds"              = "15552000"
        "customFrameOptionsValue" = "ALLOW"
        # "customFrameOptionsValue" = "SAMEORIGIN"
        "customRequestHeaders" = {
          "X-Forwarded-Proto" = "https"
        }
      }
    }
  }
}

# ------------------------------------------------------------------------------


resource "kubectl_manifest" "traefik_certificate_default" {

  depends_on = [time_sleep.traefik]

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
    - ${var.traefik_local_domain}
    - "*.${var.traefik_local_domain}"
  wildcard: true
  issuerRef:
    kind: ClusterIssuer
    name: ${var.kube_cert_cluster_issuer}
YAML

}

# ------------------------------------------------------------------------------

resource "kubernetes_secret_v1" "traefik_dashboard_credentials" {

  depends_on = [kubectl_manifest.traefik_certificate_default]

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

  depends_on = [kubectl_manifest.traefik_certificate_default]

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
    - traefik.${var.traefik_local_domain}
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
          "match" = "Host(`traefik.${var.traefik_local_domain}`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))"
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
