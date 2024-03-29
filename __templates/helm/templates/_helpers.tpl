{{/*
Expand the name of the chart.
*/}}

{{- define "helm-kube.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-kube.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-kube.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-kube.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-kube.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-kube.labels" -}}
app: {{ include "helm-kube.name" . }}
helm.sh/chart: {{ include "helm-kube.chart" . }}
# chart: {{ include "helm-kube.chart" . }}
{{ include "helm-kube.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
# app.kubernetes.io/component:
# app.kubernetes.io/part-of:
app.kubernetes.io/managed-by: {{ .Release.Service }}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
# TODO: test if this syntax is correct
{{ include .Values.labels . }}
{{- end }}

{{/*
Name of the service account to use
*/}}
{{- define "helm-kube.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "helm-kube.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
