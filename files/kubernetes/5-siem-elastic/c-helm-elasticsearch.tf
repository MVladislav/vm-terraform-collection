# ------------------------------------------------------------------------------

resource "kubectl_manifest" "elastic_elasticsearch" {

  depends_on = [kubernetes_secret_v1.elastic_elasticsearch_credentials]

  yaml_body = <<YAML
---
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: elastic-elasticsearch
  namespace: elastic
spec:
  version: 8.2.2
  volumeClaimDeletePolicy: DeleteOnScaledownOnly

  # secureSettings:
  #   - secretName: elastic-user-credentials
  #     entries:
  #       - key: elastic
  #       - key: kibana_systems

  nodeSets:
    - name: masters
      count: 1
      config:
        node.roles: ["master"]
        xpack.ml.enabled: true
        # node.remote_cluster_client: false

      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              # env:
              #   - name: ES_JAVA_OPTS
              #     value: -Xms1g -Xmx1g
              resources:
                requests:
                  cpu: 0.3
                  memory: 250Mi
                limits:
                  cpu: 1000m
                  memory: 500Mi

      volumeClaimTemplates:
        - metadata:
            name: elasticsearch-data
            namespace: elastic
          spec:
            storageClassName: longhorn
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 5Gi

    - name: data
      count: 2
      config:
        node.roles: ["data", "ingest", "ml", "transform"]
        # node.remote_cluster_client: false

      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              # env:
              #   - name: ES_JAVA_OPTS
              #     value: -Xms1g -Xmx1g
              resources:
                requests:
                  cpu: 0.3
                  memory: 500Mi
                limits:
                  cpu: 1000m
                  memory: 1Gi

      volumeClaimTemplates:
        - metadata:
            name: elasticsearch-data
            namespace: elastic
          spec:
            storageClassName: longhorn
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 5Gi

YAML

}


# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_elastic_elasticsearch" {

  depends_on = [kubectl_manifest.elastic_elasticsearch]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "elastic_elasticsearch" {

  depends_on = [time_sleep.wait_for_elastic_elasticsearch]

  metadata {
    name      = "elastic-elasticsearch"
    namespace = "elastic"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = var.kube_cert_cluster_issuer
      "traefik.ingress.kubernetes.io/router.entrypoints" = "elk-elastic"
      "traefik.ingress.kubernetes.io/router.tls"         = var.kube_traefik_tls
      "traefik.ingress.kubernetes.io/router.middlewares" = var.kube_traefik_middlewares
    }
  }

  spec {
    ingress_class_name = var.kube_cert_ingress_class

    rule {
      host = "elastic2.${var.kube_public_hostname}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "elastic-elasticsearch-es-http"
              port {
                number = 9200
              }
            }
          }
        }
      }
    }

    # (Optional) Add an SSL Certificate
    tls {
      secret_name = "elastic-elasticsearch-es-http"
      hosts       = ["elastic2.${var.kube_public_hostname}"]
    }
  }

}
