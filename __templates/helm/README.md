# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [kubectl checks](#kubectl-checks)
  - [test helm syntax](#test-helm-syntax)
  - [References](#references)

---

## kubectl checks

check version and nodes access:

```sh
$kubectl version --output=yaml
$kubectl get nodes
```

check api server flags (TODO: not working):

```sh
$kubectl ecec -n kube-system <...> -it -- kube-apiserver -h | grep "default enabled ones"
```

or

```sh
$kubectl create namespace verify-pod-security
$kubectl label namespace verify-pod-security pod-security.kubernetes.io/enforce=restricted
$kubectl get ns verify-pod-security -o yaml
$kubectl -n verify-pod-security run test --dry-run=server --image=busybox --privileged
$kubectl delete namespace verify-pod-security
```

query metrics endpoint:

```sh
$kubectl get --raw /metrics | grep pod_security_evaluations_total
```

abc:

```sh
$kubectl
```

abc:

```sh
$kubectl
```

abc:

```sh
$kubectl
```

## test helm syntax

dry-run with helm:

```sh
$helm install --debug --dry-run -n test test .
```

datree policy check:

```sh
$helm plugin install https://github.com/datreeio/helm-datree
$helm datree test . -- --values values.yaml
```

---

## References

- <https://kubernetes.io/docs/concepts/security/>
- <https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/>

---

**☕ COFFEE is a HUG in a MUG ☕**
