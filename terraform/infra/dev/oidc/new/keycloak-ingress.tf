resource "kubernetes_manifest" "keycloak-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: keycloak-ingress
    namespace: oidc
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      nginx.ingress.kubernetes.io/rewrite-target: /$1

      # fix for bad gateway upstream to big
      nginx.ingress.kubernetes.io/proxy-buffer-size: 10k
  spec:
    ingressClassName: nginx
    tls:
      - hosts:
          - ${var.hostname}
        secretName: root-certificate
    rules:
      - host: ${var.hostname}
        http:
          paths:
            - path: /oidc/?(.*)
              pathType: ImplementationSpecific
              backend:
                service:
                  name: keycloak
                  port:
                    number: 80
  EOF
  )
}