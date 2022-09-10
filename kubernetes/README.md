# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [helm resource's and config changes](#helm-resources-and-config-changes)
  - [References](#references)

---

## helm resource's and config changes

`to be add by link and value.yaml into argo-cd`

- <https://prometheus-community.github.io/helm-charts>
  - install: `kube-state-metrics`
  - config changes:
    - ```yaml
      ---
      grafana:
        adminPassword: swordfish
        ingress:
          enabled: true
          ingressClassName: traefik
          annotations:
            cert-manager.io/cluster-issuer: cert-manager-cert-cluster-issuer
            kubernetes.io/tls-acme: "true"
            traefik.ingress.kubernetes.io/router.entrypoints: websecure
            traefik.ingress.kubernetes.io/router.middlewares: ""
            traefik.ingress.kubernetes.io/router.tls: "true"
          hosts:
            - grafana.home.local
          path: /
          tls:
            - secretName: grafana-general-tls
              hosts:
                - grafana.home.local
      alertmanager:
        ingress:
          enabled: true
          ingressClassName: traefik
          annotations:
            cert-manager.io/cluster-issuer: cert-manager-cert-cluster-issuer
            kubernetes.io/tls-acme: "true"
            traefik.ingress.kubernetes.io/router.entrypoints: websecure
            traefik.ingress.kubernetes.io/router.middlewares: ""
            traefik.ingress.kubernetes.io/router.tls: "true"
          ## Redirect ingress to an additional defined port on the service
          # servicePort: 8081
          hosts:
            - alertmanager.home.local
          paths:
            - /
          tls:
            - secretName: alertmanager-general-tls
              hosts:
                - alertmanager.home.local
      prometheus:
        ingress:
          enabled: true
          ingressClassName: traefik
          annotations:
            cert-manager.io/cluster-issuer: cert-manager-cert-cluster-issuer
            kubernetes.io/tls-acme: "true"
            traefik.ingress.kubernetes.io/router.entrypoints: websecure
            traefik.ingress.kubernetes.io/router.middlewares: ""
            traefik.ingress.kubernetes.io/router.tls: "true"
          hosts:
            - prometheus.home.local
          paths:
            - /
          tls:
            - secretName: prometheus-general-tls
              hosts:
                - prometheus.home.local
      thanosRuler:
        ingress:
          enabled: true
          ingressClassName: traefik
          annotations:
            cert-manager.io/cluster-issuer: cert-manager-cert-cluster-issuer
            kubernetes.io/tls-acme: "true"
            traefik.ingress.kubernetes.io/router.entrypoints: websecure
            traefik.ingress.kubernetes.io/router.middlewares: ""
            traefik.ingress.kubernetes.io/router.tls: "true"
          hosts:
            - thanosruler.home.local
          paths:
            - /
          tls:
            - secretName: thanosruler-general-tls
              hosts:
                - thanosruler.home.local
      ```
- <https://github.com/MVladislav/vm-terraform-collection>
  - install: `checkmk | uptime-kuma |ngrok`
  - config changes:
    - ```yaml
      deployment.replicaCount: 1
      secretCredential.data.password: swordfish
      ```
    - ```yaml
      secret:
      stringData:
        config.yaml: |
          authtoken: <TOKEN>
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
              addr: <SERVICE>.<NAMESPACE>:<PORT>
      ```
- <https://github.com/MVladislav/checkmk_kube_agent>
  - install: `checkmk-agent` (not working)
  - config changes: `checkmk-monitoring`
    - ```yaml
      ---
      image:
        tag: "main_2022.09.04"
      nodeCollector:
        cadvisor:
          additionalArgs:
            - "--housekeeping_interval=30s"
            - "--max_housekeeping_interval=35s"
            - "--event_storage_event_limit=default=0"
            - "--event_storage_age_limit=default=0"
            - "--store_container_labels=false"
            - "--whitelisted_container_labels=io.kubernetes.container.name,io.kubernetes.pod.name,io.kubernetes.pod.namespace,io.kubernetes.pod.uid"
            - "--global_housekeeping_interval=30s"
            - "--event_storage_event_limit=default=0"
            - "--event_storage_age_limit=default=0"
            - "--disable_metrics=percpu,process,sched,tcp,udp,diskIO,disk,network"
            - "--disable_metrics=referenced_memory"
            - "--disable_metrics=hugetlb"
            - "--allow_dynamic_housekeeping=true"
            - "--storage_duration=1m0s"
          securityContext:
            allowPrivilegeEscalation: true
            capabilities:
              drop:
                - ALL
              add: ["SYS_PTRACE", "CAP_SYS_PTRACE"]
            privileged: false
            readOnlyRootFilesystem: true
      clusterCollector:
        ingress:
          enabled: true
          className: "traefik"
          annotations:
            cert-manager.io/cluster-issuer: cert-manager-cert-cluster-issuer
            kubernetes.io/tls-acme: "true"
            traefik.ingress.kubernetes.io/router.entrypoints: websecure
            traefik.ingress.kubernetes.io/router.middlewares: ""
            traefik.ingress.kubernetes.io/router.tls: "true"
          hosts:
            - host: checkmk-m.home.local
              paths:
                - path: /
                  pathType: Prefix
          tls:
            - secretName: checkmk-m-general-tls
              hosts:
                - checkmk-m.home.local
      ```
    - get token: `$kubectl create token --duration=0s -n checkmk-monitoring checkmk-monitoring-checkmk`
    - get cert: `$kubectl config view -n checkmk-monitoring --minify --raw --output 'jsonpath={..cluster.certificate-authority-data}' | base64 -d`
    - get internal address: `http://checkmk-monitoring-cluster-collector.checkmk-monitoring:8080`
- <https://github.com/tribe29/checkmk_kube_agent>
  - install: `checkmk-agent` (not working)
  - config changes:
    - ```yaml
      ---
      ```

---

- <https://helm.elastic.co>
  - install: `elastic ...`
  - config changes:
    - ```yaml
      ---
      ```
- <https://itzg.github.io/minecraft-server-charts>
  - install: `minecraft`
  - config changes:
    - ```yaml
      minecraftServer:
        difficulty: normal
        eula: TRUE
        forgeInstallerUrl: https://adfoc.us/serve/sitelinks/?id=271228&url=https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.1.3/forge-1.19.2-43.1.3-installer.jar
        levelType: LARGEBIOMES
        maxPlayers: 5
        maxWorldSize: 20000
        nodePort: 30003
        overrideServerProperties: true
        paperDownloadUrl: https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/138/downloads/paper-1.19.2-138.jar
        serviceType: NodePort
        type: FORGE
        viewDistance: 20
        worldSaveName: home-world
        dataDir:
            enabled: true
        dataDir:
            Size: 8Gi
        replicaCount: 1
        resources:
          requests:
            cpu: 1000m
            memory: 1Gi
      ```
- <https://buttahtoast.github.io/helm-charts>
  - install: `csgo`
  - config changes:
    - ```yaml
      ---
      ```
- <https://charts.truecharts.org>
  - install: `csgo | cssource | cstrike1-6`
  - config changes:
    - ```yaml
      ---
      ```
- other out of topic linux game sources:
  - <https://github.com/mikeroyal/Retro-Gaming-Guide>
  - <https://github.com/Chevek/Gaming-Flatpak>

---

## References

- <>

---

**☕ COFFEE is a HUG in a MUG ☕**
