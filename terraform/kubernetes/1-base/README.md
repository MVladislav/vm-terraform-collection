# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [create `credentials` file](#create-credentials-file)
  - [References](#references)

---

## create `credentials` file

create file named `credentials.auto.tfvars` and fill it like following:

```tf
kube_config_path    = "~/.kube/config"
kube_config_context = "<CONTEXT>"

kube_cert_cluster_issuer = "<NAME>"
kube_cert_ingress_class = "traefik"
```

---

## References

- <https://artifacthub.io/packages/helm/longhorn/longhorn>
- <https://www.youtube.com/watch?v=eKBBHc0t7bc>

---

**☕ COFFEE is a HUG in a MUG ☕**
