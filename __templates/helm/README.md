# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [test helm syntax](#test-helm-syntax)
  - [References](#references)

---

## test helm syntax

dry-run with helm:

```sh
$helm install --debug --dry-run test .
```

datree policy check:

```sh
$helm plugin install https://github.com/datreeio/helm-datree
$helm datree test . -- --values values.yaml
```

---

## References

- <>

---

**☕ COFFEE is a HUG in a MUG ☕**
