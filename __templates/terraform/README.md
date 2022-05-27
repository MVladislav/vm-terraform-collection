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
# docker_config_host  = "unix:///var/run/docker.sock"

kube_cert_cluster_issuer = "<NAME>"
kube_cert_ingress_class = "traefik"
```

---

## References

- <>

---

**☕ COFFEE is a HUG in a MUG ☕**
