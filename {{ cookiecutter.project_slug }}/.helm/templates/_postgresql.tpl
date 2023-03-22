{{/*
Add environment variables to configure postgres values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.database.host" -}}
{{- ternary (include "<%= cookiecutter.project_slug | to_lower_camel %>.postgresql.fullname" . ) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environment variables to configure postgres values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Add environment variables to configure postgres values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.database.user" -}}
{{- if .Values.postgresql.enabled }}
  {{- .Values.postgresql.auth.username | quote -}}
{{- else }}
  {{- .Values.externalDatabase.user | quote -}}
{{- end }}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.database.existingsecret.key" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%s" "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- printf "%s" "password" -}}
        {{- end -}}
    {{- else -}}
        {{- printf "%s" "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.database.name" -}}
{{- if .Values.postgresql.enabled }}
  {{- .Values.postgresql.auth.database | quote -}}
{{- else -}}
  {{- .Values.externalDatabase.database | quote -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure postgres values
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.env.postgres" -}}
- name: POSTGRES_HOST
  value: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.database.host" . }}

- name: POSTGRES_PORT
  value: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.database.port" . }}

- name: POSTGRES_USER
  value: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.database.user" . }}

- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.postgresql.secretName" . }}
      key: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.database.existingsecret.key" . }}

- name: POSTGRES_DATABASE
  value: {{ include "<%= cookiecutter.project_slug | to_lower_camel %>.database.name" . }}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "{{ cookiecutter.project_slug  }}.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
  {{- default (include "{{ cookiecutter.project_slug  }}.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
{{- else -}}
  {{- default (printf "%s-externaldb" .Release.Name) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}
