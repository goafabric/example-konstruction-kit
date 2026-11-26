kubectl apply -f - <<EOF
  apiVersion: api.kagent.dev/v1alpha3
  kind: ModelConfig
  metadata:
    name: openai-model-config
    namespace: kagent
  spec:
    apiKeySecret: kagent-openai
    apiKeySecretKey: OPENAI_API_KEY
    model: ${OPENAI_CHAT_MODEL}
    provider: OpenAI
    openAI:
      baseUrl: ${OPENAI_BASE_URL}
EOF