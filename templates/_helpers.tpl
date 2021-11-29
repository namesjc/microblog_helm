{{/*
Expand the name of the chart.
*/}}
{{- define "microblog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "microblog.fullname" -}}
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

{{- define "microblog.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-"  -}}
{{- end }}

{{- define "microblog.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-"  -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "microblog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the proper Storage Class
*/}}
{{- define "microblog.storageClass" -}}
{{- $storageClass := .Values.persistence.storageClass -}}
{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "microblog.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-%s" (include "microblog.mariadb.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "microblog.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "microblog.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "microblog.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "microblog.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "microblog.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (include "microblog.mariadb.fullname" .) -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "microblog.fullname" .) "external" -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "microblog.databasePasswordKey" -}}
{{- if .Values.mariadb.enabled -}}
    mariadb-password
{{- else -}}
    db-password
{{- end -}}
{{- end -}}

{{/*
Return the Redis Hostname
*/}}
{{- define "microblog.redisHost" -}}
{{- if .Values.redis.enabled }}
    {{- if .Values.redis.sentinel.enabled }}
        {{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
    {{- else }}
        {{- printf "%s-%s-%s" .Release.Name "redis" "master" | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- else }}
    {{- printf "%s" .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis Port
*/}}
{{- define "microblog.redisPort" -}}
{{- if .Values.redis.enabled }}
    {{- if .Values.redis.sentinel.enabled }}
        {{- printf "%d" (.Values.redis.sentinel.service.sentinelPort | int ) -}}
    {{- else }}
        {{- printf "%d" (.Values.redis.master.service.port | int ) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%d" (.Values.externalRedis.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis Secret Name
*/}}
{{- define "microblog.redisSecretName" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s" (include "microblog.redis.fullname" .) -}}
{{- else if .Values.externalRedis.existingSecret -}}
    {{- printf "%s" .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "microblog.fullname" .) "external" -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "microblog.redisPasswordKey" -}}
{{- if .Values.redis.enabled -}}
    redis-password
{{- else -}}
    redis-password
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "microblog.elasticsearchHost" -}}
{{- if .Values.elasticsearch.enabled }}
    {{- printf "%s-%s-coordinating-only" .Release.Name "elasticsearch" | trunc 63 | trimSuffix "-" -}}
{{- else }}
    {{- printf "%s" .Values.externalElasticsearch.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Elasticsearch Port
*/}}
{{- define "microblog.elasticsearchPort" -}}
{{- if .Values.elasticsearch.enabled }}
    {{- printf "9200" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalelasticsearch.port | int ) -}}
{{- end -}}
{{- end -}}
