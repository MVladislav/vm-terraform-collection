# ------------------------------------------------------------------------------

resource "kubernetes_secret_v1" "mysql_credentials" {

  depends_on = [kubernetes_namespace.mysql]

  metadata {
    name      = "mysql-credentials"
    namespace = "mysql"
  }

  data = {
    "mysql-root-password"        = var.mysql_credentials_root_password
    "mysql-replication-password" = var.mysql_credentials_replication_password
    # "mysql-password"             = var.mysql_credentials_password
  }

}
