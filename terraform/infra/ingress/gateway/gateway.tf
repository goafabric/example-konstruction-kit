# see: https://apisix.apache.org/docs/ingress-controller/reference/apisix-ingress-controller/examples/#define-controller-and-gateway
resource "kubernetes_manifest" "apisix_gatewayclass" {
  manifest = yamldecode(<<-EOF
  apiVersion: gateway.networking.k8s.io/v1
  kind: GatewayClass
  metadata:
    name: apisix
  spec:
    controllerName: apisix.apache.org/apisix-ingress-controller
  EOF
  )
}

resource "kubernetes_manifest" "apisix_gateway" {
  manifest = yamldecode(<<-EOF
  apiVersion: gateway.networking.k8s.io/v1
  kind: Gateway
  metadata:
    namespace: ingress-apisix
    name: apisix
  spec:
    gatewayClassName: apisix
    listeners:
      - name: http
        protocol: HTTP
        port: 80
        allowedRoutes:
          namespaces:
            from: All
      - name: https
        port: 443
        protocol: HTTPS
        hostname: ${var.hostname}
        allowedRoutes:
          namespaces:
            from: All
        tls:
          mode: Terminate
          certificateRefs:
            - kind: Secret
              name: root-certificate
    infrastructure:
      parametersRef:
        group: apisix.apache.org
        kind: GatewayProxy
        name: apisix-config
  EOF
  )
}
