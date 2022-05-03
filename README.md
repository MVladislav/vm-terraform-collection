# Terraform Collection

```sh
  MVladislav
```

---

- [Terraform Collection](#terraform-collection)
  - [install](#install)
  - [general commands](#general-commands)
  - [References](#references)

---

## install

```sh

$curl -sL "https://apt.releases.hashicorp.com/gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/apt.releases.hashicorp.com.gpg >/dev/null
$echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/apt.releases.hashicorp.com.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-$(lsb_release -cs).list"
$sudo apt update && sudo apt install terraform
```

## general commands

setup initial sources:

```sh
$terraform init
```

check script:

```sh
$terraform plan
```

eun script:

```sh
$terraform apply
```

---

## References

- <https://www.terraform.io/downloads>
- <https://github.com/sl1pm4t/k2tf>

---

**☕ COFFEE is a HUG in a MUG ☕**
