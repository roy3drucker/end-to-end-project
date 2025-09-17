{{/*
Common labels
*/}}
{{- define "flask-aws-monitor.labels" -}}
app.kubernetes.io/name: flask-aws-monitor
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flask-aws-monitor.selectorLabels" -}}
app.kubernetes.io/name: flask-aws-monitor
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}