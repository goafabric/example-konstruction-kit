resource "kubernetes_manifest" "oidc-plugin" {
  manifest   = yamldecode(<<-EOF
  apiVersion: configuration.konghq.com/v1
  kind: KongPlugin
  metadata:
    name: oidc-plugin
    namespace: example
  plugin: oidc
  config:
    client_id: oauth2-proxy
    client_secret: none
    discovery: http://keycloak-application.oidc:8080/oidc/realms/tenant-0/.well-known/openid-configuration
  EOF
  )
}