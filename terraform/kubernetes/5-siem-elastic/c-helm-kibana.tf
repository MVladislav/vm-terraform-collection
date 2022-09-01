# ------------------------------------------------------------------------------

resource "kubectl_manifest" "elastic_kibana" {

  depends_on = [
    time_sleep.wait_for_elastic_elasticsearch,
    kubernetes_secret_v1.elastic_kibana_encryption_key
  ]

  yaml_body = <<YAML
---
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: elastic-kibana
  namespace: elastic
spec:
  version: 8.2.2
  count: 1

  elasticsearchRef:
    name: elastic-elasticsearch
    namespace: elastic

  secureSettings:
    - secretName: elastic-kibana-kb-secure-settings

  podTemplate:
    spec:
      containers:
        - name: kibana
          env:
            - name: NODE_OPTIONS
              value: "--max-old-space-size=2048"
            # - name: ES_JAVA_OPTS
            #   value: -Xms1g -Xmx1g
          resources:
            requests:
              cpu: 0.3
              memory: 250Mi
            limits:
              cpu: 1000m
              memory: 500Mi
      # nodeSelector:
      #   type: frontend

YAML

}


# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_elastic_kibana" {

  depends_on = [kubectl_manifest.elastic_kibana]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "elastic_kibana" {

  depends_on = [time_sleep.wait_for_elastic_kibana]

  metadata {
    name      = "elastic-kibana"
    namespace = "elastic"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = var.kube_cert_cluster_issuer
      "traefik.ingress.kubernetes.io/router.entrypoints" = var.kube_traefik_entrypoints
      "traefik.ingress.kubernetes.io/router.tls"         = var.kube_traefik_tls
      "traefik.ingress.kubernetes.io/router.middlewares" = var.kube_traefik_middlewares
    }
  }

  spec {
    ingress_class_name = var.kube_cert_ingress_class

    rule {
      host = "kibana2.${var.kube_public_hostname}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "elastic-kibana-kb-http"
              port {
                number = 5601
              }
            }
          }
        }
      }
    }

    # (Optional) Add an SSL Certificate
    tls {
      secret_name = "elastic-kibana-kb-http"
      hosts       = ["kibana2.${var.kube_public_hostname}"]
    }
  }

}
