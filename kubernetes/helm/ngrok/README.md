# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [examples](#examples)
    - [start by file secret](#start-by-file-secret)
  - [References](#references)

---

## examples

### start by file secret

by default ngrok will start all defined tunnels defined in the file\
`/tmp/config.yaml`, which by default will mount into deployment\
and needs to be set in the secret.

```yaml
secret:
  stringData:
    config.yaml: |
      authtoken: <AUTH_TOKEN>

      version: 2

      region: eu
      console_ui: "iftty"
      inspect_db_size: 0
      log_level: info
      log_format: term
      log: false # /var/log/ngrok.log
      update: false
      update_channel: stable
      web_addr: 0.0.0.0:4040

      tunnels:
        <NAME>:
          proto: tcp
          addr: <SERVICE_NAME>.<NAMESPACE_NAME>:<SERVICE_PORT>
```

---

## References

- <>

---

**☕ COFFEE is a HUG in a MUG ☕**
