{{/*
Render pullSecret content
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.pullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.pullSecret.registry (printf "%s:%s" .Values.pullSecret.username .Values.pullSecret.password | b64enc) | b64enc }}
{{- end }}

{{/*
Image for application
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.image" -}}
{{ include "common.images.image" ( dict "imageRoot" .Values.image ) }}
{{- end -}}

{{/*
Create a celery broker url
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.backend.env.celeryBrokerUrl" -}}
{{ ternary ( printf "redis://%s:%s/%s" ( include "<%= cookiecutter.project_slug | to_lower_camel %>.redis.fullname" . ) "6379" "0" ) .Values.externalCeleryBrokerUrl .Values.redis.enabled | quote }}
{{- end -}}

{{/*
Add environment variables to configure application
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.env" -}}
{{ include "<%= cookiecutter.project_slug | to_lower_camel %>.env.postgres" . }}

- name: SERVER_PORT
  value: "{{ .Values.api.containerPort }}"
{{- end }}

{{/*
Create a default fully qualified job name.
Due to the job only being allowed to run once, we add the chart revision so helm
upgrades don't cause errors trying to create the already ran job.
Due to the helm delete not cleaning up these jobs, we add a random value to
reduce collision
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.migrations.jobname" -}}
{{- $name := include "common.names.fullname" . | trunc 55 | trimSuffix "-" -}}
{{- printf "%s-%s-%d" $name "migrations" .Release.Revision | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "<%= cookiecutter.project_slug | to_lower_camel %>.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis-master" "chartValues" .Values.redis "context" $) -}}
{{- end -}}
