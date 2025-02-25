{{/*
Expand the name of the chart.
*/}}
{{- define "service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "service.fullname" -}}
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
{{- define "service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "service.labels" -}}
helm.sh/chart: {{ include "service.chart" . }}
{{ include "service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Create the volumes 
*/}}
{{- define "service.volumes" -}}
{{- if .Values.config.enabled }}
- name: config-volume
  configMap:
    name: {{ .Values.config.name }}
    items:
      - key: {{ .Values.config.key }}
        path: {{ .Values.config.path }}
{{- end }}
{{- if .Values.volume.enabled }}
{{- $name := include "service.name" . }}
{{- range $key, $value := .Values.volume.options }}
- name: "{{ $name }}-{{ $value.name }}-{{ $key }}"
  persistentVolumeClaim:
    claimName: "{{ $name }}-{{ $value.name }}-{{ $key }}"
{{- end }}
{{- end }}
{{- end }}


{{/*
Create the volumeMounts 
*/}}
{{- define "service.volumeMounts" -}}
{{- $name := include "service.name" . }}
{{- if .Values.config.enabled }}
- name: config-volume
  mountPath: "{{ .Values.config.mountPath }}{{ .Values.config.path }}"
  subPath: {{ .Values.config.path }}
{{- end }}
{{- if .Values.volume.enabled }}
{{- range $key, $value := .Values.volume.options }}
- name: "{{ $name }}-{{ $value.name }}-{{ $key }}"
  mountPath: {{ $value.path }}
{{- end }}
{{- end }}
{{- end }}
