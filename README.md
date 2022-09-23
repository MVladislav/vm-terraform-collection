# Terraform Collection

```sh
  MVladislav
```

---

- [Terraform Collection](#terraform-collection)
  - [install](#install)
  - [general commands](#general-commands)
    - [terraform](#terraform)
    - [kubernetes](#kubernetes)
  - [References](#references)

---

## install

```sh

$curl -sL "https://apt.releases.hashicorp.com/gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/apt.releases.hashicorp.com.gpg >/dev/null
$echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/apt.releases.hashicorp.com.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-$(lsb_release -cs).list"
$sudo apt update && sudo apt install terraform
```

## general commands

### terraform

setup initial sources:

```sh
$terraform init
```

check script:

```sh
$terraform plan
```

run script:

```sh
$terraform apply
```

### kubernetes

list everything:

```sh
$kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n <namespace>
```

---

## References

- <https://www.terraform.io/downloads>
- <https://github.com/sl1pm4t/k2tf>

---

**☕ COFFEE is a HUG in a MUG ☕**
