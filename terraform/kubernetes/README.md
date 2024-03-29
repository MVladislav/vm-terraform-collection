# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [Kubernetes setup [server]](#kubernetes-setup-server)
  - [Kubectl setup [client]](#kubectl-setup-client)
    - [get cluster conf to connect to](#get-cluster-conf-to-connect-to)
  - [Helm setup [client] (optional)](#helm-setup-client-optional)
  - [References](#references)

---

## Kubernetes setup [server]

> kubernetes setup as k3s for home

install main server:

```sh
$curl -sfL https://get.k3s.io | sh -s - server \
--token=<TOKEN> \
--tls-san <DNS-NAME-MAIN> --tls-san <IP-ADDRESS-MAIN> \
--no-deploy traefik \
--cluster-init
```

install slave server:

```sh
$curl -sfL https://get.k3s.io | sh -s - server \
--token=<TOKEN> \
--tls-san <DNS-NAME-MAIN> --tls-san <IP-ADDRESS-MAIN> \
--no-deploy traefik \
--server https://<IP-ADDRESS-MAIN>:6443
```

install agents:

```sh
$curl -sfL https://get.k3s.io | sh -s - agent \
--token=<TOKEN> \
--server https://<IP-ADDRESS-MAIN>:6443
```

## Kubectl setup [client]

install kubectl on your device _(apt | snap)_:

apt:

```sh
$curl -sL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/kubernetes-archive-keyring.gpg >/dev/null
# $echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/kubernetes-$(lsb_release -cs).list"
$echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee "/etc/apt/sources.list.d/kubernetes-xenial.list"
$sudo apt update && sudo apt install kubectl
```

snap:

```sh
$sudo snap install kubectl --classic
```

config:

```sh
$mkdir ~/.kube && cd ~/.kube
```

### get cluster conf to connect to

we need the `k3s` file from the server, which is located under `/etc/rancher/k3s/k3s.yaml`
and needs to be copied into `~/.kube` on you client system named as `config`.

You also should change some line in that file like follow:

- server -> change it to `<DNS-NAME-MAIN>` _(or `<IP-ADDRESS-MAIN>`)_ with port `6443`
- all namespaces `default` -> to how ever you identify your cluster

now switch into new context:

```sh
$kubectl config get-contexts
$kubectl config use <context >
```

## Helm setup [client] (optional)

install helm on your device _(apt | snap)_:

apt:

```sh
$...
```

snap:

```sh
$sudo apt install helm --classic
```

---

## References

- <https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/>
- <https://helm.sh/docs/intro/install>
- <https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/>

---

**☕ COFFEE is a HUG in a MUG ☕**
