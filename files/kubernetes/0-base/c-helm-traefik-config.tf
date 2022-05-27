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

resource "kubernetes_manifest" "traefik_middleware_header_default" {

  depends_on = [helm_release.traefik]

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
