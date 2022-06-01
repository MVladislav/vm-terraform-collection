# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [... setup](#-setup)
  - [create `credentials` file](#create-credentials-file)
  - [References](#references)

---

## ... setup

## create `credentials` file

create file named `credentials.auto.tfvars` and fill it like following:

```tf
kube_config_path    = "~/.kube/config"
kube_config_context = "<CONTEXT>"

kube_cert_cluster_issuer = "<NAME>"
kube_cert_ingress_class  = "traefik"

kube_traefik_entrypoints = "websecure"
kube_traefik_tls         = "true"
kube_traefik_middlewares = ""
kube_public_hostname     = "home.local"
```

---

## References

- <https://artifacthub.io/packages/helm/elastic/eck-operator>

---

**☕ COFFEE is a HUG in a MUG ☕**
