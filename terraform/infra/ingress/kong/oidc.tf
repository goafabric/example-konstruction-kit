resource "kubernetes_manifest" "grafana-gateway" {
  manifest   = yamldecode(<<-EOF
  apiVersion: configuration.konghq.com/v1
  kind: KongPlugin
  metadata:
    name: {{ include "application.fullname" . }}-oidc-plugin
  plugin: oidc
  config:
    client_id: oauth2-proxy
    client_secret: none
    discovery: http://keycloak-application.oidc:8080/oidc/realms/tenant-0/.well-known/openid-configuration
    logout_path: "/logout"
  EOF
  )
}