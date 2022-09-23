resource "kubernetes_namespace" "elastic_eck_operator" {

  metadata {
    name = "elastic"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "elastic_eck_operator" {

  depends_on = [kubernetes_namespace.elastic_eck_operator]

  name      = "elastic-eck-operator"
  namespace = "elastic"

  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  version    = "2.2.0"

  # DEFAULT setup
  set {
    name  = "replicaCount"
    value = 1
  }

  # LOAD from values-file
  values = [
    templatefile("values/values.yaml", {

    })
  ]

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_elastic_eck_operator" {

  depends_on = [helm_release.elastic_eck_operator]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------
