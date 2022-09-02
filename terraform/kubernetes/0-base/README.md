# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [create `credentials` file](#create-credentials-file)
    - [create self-signed-cert](#create-self-signed-cert)
    - [create traefik conf files](#create-traefik-conf-files)
  - [argo-cd](#argo-cd)
    - [change admin password](#change-admin-password)
  - [References](#references)

---

## create `credentials` file

create file named `credentials.auto.tfvars` and fill it like following:

```tf
kube_config_path    = "~/.kube/config"
kube_config_context = "<CONTEXT>"

kube_cert_cluster_issuer = "<NAME>"
kube_cert_ingress_class = "traefik"

# run `$cat <crt|key-file> | base64 -w 0`
cert_manager_secret_crt = "<base64-crt>"
cert_manager_secret_key = "<base64-key>"

traefik_username = "<USERNAME>"
traefik_password = "<PASSWORD>"

kube_traefik_entrypoints = "websecure"
kube_traefik_tls         = "true"
kube_traefik_middlewares = ""
kube_public_hostname     = "home.local"
```

### create self-signed-cert

```sh
$openssl genrsa -out ca.key 4096
$openssl req -new -x509 -sha256 -days 365 -key ca.key -out ca.crt
$cat ca.crt | base64 -w 0
$cat ca.key | base64 -w 0
```

### create traefik conf files

> they can be empty, but are needed

```sh
$mkdir -p values && touch values/{traefik,traefik-config,traefik-config-http,traefik-config-tcp,traefik-config-udp}.yaml
```

## argo-cd

when argo-cd is deployed, you can get the password for `admin` user, like follow:

```sh
$kubectl -n argo-cd get secrets argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### change admin password

```sh
$python3 -c "import bcrypt; print(bcrypt.hashpw(b'YOUR-PASSWORD-HERE', bcrypt.gensalt()).decode())"
$kubectl -n argo-cd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
```

---

## References

- <https://artifacthub.io/packages/helm/traefik/traefik?modal=values&path=securityContext>
- <https://doc.traefik.io/traefik/routing/providers/kubernetes-ingress/>

---

**☕ COFFEE is a HUG in a MUG ☕**
