resource "kubernetes_secret_v1" "elastic_elasticsearch_credentials" {

  metadata {
    name      = "elastic-elasticsearch-es-elastic-user"
    namespace = "elastic"

    labels = {
      "common.k8s.elastic.co/type"                = "elasticsearch"
      "eck.k8s.elastic.co/credentials"            = "true"
      "eck.k8s.elastic.co/owner-kind"             = "Elasticsearch"
      "eck.k8s.elastic.co/owner-name"             = "elastic-elasticsearch"
      "eck.k8s.elastic.co/owner-namespace"        = "elastic"
      "elasticsearch.k8s.elastic.co/cluster-name" = "elastic-elasticsearch"
    }

  }

  data = {
    elastic = var.elastic_cred_elasticsearch_password
  }

}

# ------------------------------------------------------------------------------

resource "kubernetes_secret_v1" "elastic_kibana_encryption_key" {

  metadata {
    name      = "elastic-kibana-kb-secure-settings"
    namespace = "elastic"
  }

  data = {
    "xpack.security.encryptionKey" = var.elastic_cred_kibana_secret_key
  }

}
