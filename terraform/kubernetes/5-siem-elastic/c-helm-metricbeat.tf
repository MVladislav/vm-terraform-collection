# ------------------------------------------------------------------------------

resource "kubectl_manifest" "elastic_metricbeat_service_account" {

  depends_on = [
    time_sleep.wait_for_elastic_elasticsearch,
    time_sleep.wait_for_elastic_kibana
  ]

  yaml_body = <<YAML
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: elastic-metricbeat
  namespace: elastic
YAML

}

resource "kubectl_manifest" "elastic_metricbeat_cluster_role" {

  depends_on = [
    time_sleep.wait_for_elastic_elasticsearch,
    time_sleep.wait_for_elastic_kibana
  ]

  yaml_body = <<YAML
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: elastic-metricbeat
  namespace: elastic
rules:
  - apiGroups:
      - ""
    resources:
      - nodes
      - namespaces
      - events
      - pods
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - "extensions"
    resources:
      - replicasets
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - apps
    resources:
      - statefulsets
      - deployments
      - replicasets
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ""
    resources:
      - nodes/stats
    verbs:
      - get
  - nonResourceURLs:
      - /metrics
    verbs:
      - get
YAML

}

resource "kubectl_manifest" "elastic_metricbeat_cluster_role_binding" {

  depends_on = [
    kubectl_manifest.elastic_metricbeat_service_account,
    kubectl_manifest.elastic_metricbeat_cluster_role
  ]

  yaml_body = <<YAML
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: elastic-metricbeat
  namespace: elastic
subjects:
  - kind: ServiceAccount
    name: elastic-metricbeat
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: elastic-metricbeat
  apiGroup: rbac.authorization.k8s.io
YAML

}

resource "kubectl_manifest" "elastic_metricbeat" {

  depends_on = [kubectl_manifest.elastic_metricbeat_cluster_role_binding]

  yaml_body = <<YAML
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: elastic-metricbeat
  namespace: elastic
spec:
  type: metricbeat
  version: 8.2.0

  elasticsearchRef:
    name: elastic-elasticsearch
  kibanaRef:
    name: elastic-kibana

  config:
    metricbeat:
      autodiscover:
        providers:
          - hints:
              default_config: {}
              enabled: "true"
            node: $${NODE_NAME}
            type: kubernetes
      modules:
        - module: system
          period: 10s
          metricsets:
            - cpu
            - load
            - memory
            - network
            - process
            - process_summary
          process:
            include_top_n:
              by_cpu: 5
              by_memory: 5
          processes:
            - .*
        - module: system
          period: 1m
          metricsets:
            - filesystem
            - fsstat
          processors:
            - drop_event:
                when:
                  regexp:
                    system:
                      filesystem:
                        mount_point: ^/(sys|cgroup|proc|dev|etc|host|lib)($|/)
        - module: kubernetes
          period: 10s
          node: $${NODE_NAME}
          hosts:
            - https://$${NODE_NAME}:10250
          bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
          ssl:
            verification_mode: none
          metricsets:
            - node
            - system
            - pod
            - container
            - volume
    processors:
      - add_cloud_metadata: {}
      - add_host_metadata: {}
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: elastic-metricbeat
        automountServiceAccountToken: true # some older Beat versions are depending on this settings presence in k8s context
        containers:
          - name: metricbeat
            args:
              - -e
              - -c
              - /etc/beat.yml
              - -system.hostfs=/hostfs
            volumeMounts:
              - mountPath: /hostfs/sys/fs/cgroup
                name: cgroup
              - mountPath: /var/run/docker.sock
                name: dockersock
              - mountPath: /hostfs/proc
                name: proc
            env:
              - name: NODE_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: spec.nodeName
            resources:
              requests:
                cpu: 0.3
                memory: 250Mi
              limits:
                cpu: 1000m
                memory: 500Mi
        dnsPolicy: ClusterFirstWithHostNet
        hostNetwork: true # Allows to provide richer host metadata
        securityContext:
          runAsUser: 0
        terminationGracePeriodSeconds: 30
        volumes:
          - hostPath:
              path: /sys/fs/cgroup
            name: cgroup
          - hostPath:
              path: /var/run/docker.sock
            name: dockersock
          - hostPath:
              path: /proc
            name: proc

YAML

}

# ------------------------------------------------------------------------------

resource "time_sleep" "wait_for_elastic_metricbeat" {

  depends_on = [kubectl_manifest.elastic_metricbeat]

  create_duration = "30s"

}

# ------------------------------------------------------------------------------
