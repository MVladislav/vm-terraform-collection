resource "kubernetes_namespace" "cert_manager" {

  # depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "cert-manager"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "cert_manager" {

  depends_on = [kubernetes_namespace.cert_manager]

  name      = "cert-manager"
  namespace = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "replicaCount"
    value = 2
  }

  # install kubernetes CRDs (CRD -> Customer Role Definitions)
  set {
    name  = "installCRDs"
    value = "true"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_certmanager" {

  depends_on = [helm_release.cert_manager]

  create_duration = "55s"

}

# ------------------------------------------------------------------------------

variable "cert_manager_secret_crt" {
  type      = string
  sensitive = true
}

variable "cert_manager_secret_key" {
  type      = string
  sensitive = true
}

resource "kubectl_manifest" "cert_manager_selfsigned_secret" {

  depends_on = [time_sleep.wait_for_certmanager]

  yaml_body = <<YAML
---
apiVersion: v1
kind: Secret
metadata:
  name: cert-manager-home-local
  namespace: cert-manager
data:
  tls.ca: ${var.cert_manager_secret_crt}
  tls.crt: ${var.cert_manager_secret_crt}
  tls.key: ${var.cert_manager_secret_key}
  YAML

}

# ------------------------------------------------------------------------------

resource "kubectl_manifest" "cert_manager_selfsigned_custer" {

  depends_on = [time_sleep.wait_for_certmanager]

  yaml_body = <<YAML
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cert-manager-selfsigned-cluster
spec:
  ca:
    secretName: cert-manager-home-local
  YAML

}


resource "kubectl_manifest" "cert_manager_selfsigned_cert" {

  depends_on = [time_sleep.wait_for_certmanager]

  yaml_body = <<YAML
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cert-manager-selfsigned-cert
  namespace: cert-manager
spec:
  isCA: true
  duration: 43800h
  commonName: intermediate-ca
  secretName: cert-manager-home-local
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: cert-manager-selfsigned
    kind: ClusterIssuer
YAML

}

resource "time_sleep" "wait_for_clusterissuer" {

  depends_on = [kubectl_manifest.cert_manager_selfsigned_custer]

  create_duration = "30s"

}
