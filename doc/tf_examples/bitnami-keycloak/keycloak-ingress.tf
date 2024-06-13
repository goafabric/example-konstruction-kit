resource "kubernetes_manifest" "keycloak-route" {
  manifest   = yamldecode(<<-EOF
  apiVersion: apisix.apache.org/v2
  kind: ApisixRoute
  metadata:
    name: keycloak-route
  spec:
    http:
      - name: keycloak
        match:
          hosts:
            - ${var.hostname}
          paths:
            - /oidc
            - /oidc/*
        backends:
          - serviceName: keycloak
            servicePort: http
        plugins:
          - name: redirect
            enable: true
            config:
              http_to_https: true
  EOF
  )
}

resource "kubernetes_manifest" "keycloak-ingress" {
  manifest   = yamldecode(<<-EOF
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: keycloak-ingress
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
  spec:
    ingressClassName: kong
    tls:
      - hosts:
          - ${var.hostname}
        secretName: root-certificate
    rules:
      - host: ${var.hostname}
        http:
          paths:
            - path: /oidc
              pathType: ImplementationSpecific
              backend:
                service:
                  name: keycloak
                  port:
                    name: 80
  EOF
  )
}