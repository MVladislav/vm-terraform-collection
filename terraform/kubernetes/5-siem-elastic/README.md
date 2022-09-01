# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [... setup](#-setup)
  - [create `credentials` file](#create-credentials-file)
  - [infos](#infos)
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

elastic_cred_elasticsearch_password = <PASSWORD>
elastic_cred_kibana_password        = <PASSWORD>
elastic_cred_kibana_secret_key      = <SECRET>
```

## infos

on hosts you need to run:

```sh
$sudo sysctl -w vm.max_map_count=262144
```

---

## References

- <https://artifacthub.io/packages/helm/elastic/eck-operator>
- <https://www.elastic.co/guide/en/cloud-on-k8s/2.2/k8s-managing-compute-resources.html>
- <https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-beat-configuration-examples.html>
- <https://github.com/elastic/cloud-on-k8s/blob/2.2/config/crds/v1/all-crds.yaml>

---

**☕ COFFEE is a HUG in a MUG ☕**
