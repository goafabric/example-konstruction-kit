apiVersion: v1
kind: Secret
metadata:
  name: {{ include "application.fullname" . }}-secret
  labels:
    {{- include "application.labels" . | nindent 4 }}

data:
  spring.kafka.username: "YWRtaW4="
  spring.kafka.password: {{ .Values.messageBroker.password | b64enc }}