resource "kubernetes_namespace" "mysql" {

  # depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "mysql"
  }

}

# ------------------------------------------------------------------------------

resource "helm_release" "mysql" {

  depends_on = [kubernetes_namespace.mysql, kubernetes_secret_v1.mysql_credentials]

  name      = "mysql"
  namespace = "mysql"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  version    = "9.1.1"

  # DEFAULT setup
  set {
    name  = "secondary.replicaCount"
    value = 1
  }
  set {
    name  = "architecture"
    value = "replication"
  }

  # USER setup
  # set {
  #   name  = "auth.rootPassword"
  #   value = var.mysql_root_password
  # }
  # set {
  #   name  = "auth.username"
  #   value = var.mysql_username
  # }
  # set {
  #   name  = "auth.password"
  #   value = var.mysql_password
  # }
  # set {
  #   name  = "auth.database"
  #   value = var.mysql_database
  # }

  # MYSQL setup
  set {
    name  = "auth.existingSecret"
    value = "mysql-credentials"
  }
  # MYSQL setup : primary
  set {
    name  = "primary.persistence.storageClass"
    value = "longhorn"
  }
  set {
    name  = "primary.persistence.size"
    value = "5Gi"
  }
  # MYSQL setup : secondary
  set {
    name  = "secondary.persistence.storageClass"
    value = "longhorn"
  }
  set {
    name  = "secondary.persistence.size"
    value = "5Gi"
  }

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_mysql" {

  depends_on = [helm_release.mysql]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "helm_release" "mysql_phpmyadmin" {

  depends_on = [time_sleep.wait_for_mysql]

  name      = "mysql-phpmyadmin"
  namespace = "mysql"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "phpmyadmin"
  version    = "10.1.5"

  # MYSQL setup
  set {
    name  = "db.host"
    value = "mysql-primary"
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
    value = var.kube_traefik_entrypoints
  }
  # set {
  #   name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls"
  #   value = var.kube_traefik_tls
  # }
  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = var.kube_traefik_middlewares
  }
  set {
    name  = "ingress.enabled"
    value = true
  }
  set {
    name  = "ingress.certManager"
    value = true
  }
  set {
    name  = "ingress.tls"
    value = true
  }
  set {
    name  = "ingress.hostname"
    value = "mysql.home.local"
  }

  # LOAD from values-file
  values = [
    templatefile("values/values.yaml", {

    })
  ]

}

# ------------------------------------------------------------------------------
