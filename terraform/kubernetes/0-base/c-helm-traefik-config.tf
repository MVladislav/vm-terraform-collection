resource "kubernetes_config_map_v1" "traefik_config" {

  depends_on = [kubernetes_namespace.traefik]

  metadata {
    name      = "traefik-configs"
    namespace = "traefik"
    labels = {
      app   = "traefik"
      chart = "traefik"
    }
  }

  data = {
    "config.yml"      = "${file("${path.module}/values/traefik-config.yaml")}"
    "config-http.yml" = "${file("${path.module}/values/traefik-config-http.yaml")}"
    "config-tcp.yml"  = "${file("${path.module}/values/traefik-config-tcp.yaml")}"
    "config-udp.yml"  = "${file("${path.module}/values/traefik-config-udp.yaml")}"
  }
}
