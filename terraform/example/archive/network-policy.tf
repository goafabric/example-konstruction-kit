resource "kubernetes_manifest" "allow-ingress" {
  manifest   = yamldecode(<<-EOF
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: allow-ingress
      namespace: example
    spec:
      podSelector: {}
      policyTypes:
        - Ingress
      ingress:
        - from:
            - namespaceSelector:
                matchLabels:
                  name: ingress-apisix
    EOF
  )
}

resource "kubernetes_manifest" "allow-person-service" {
  manifest   = yamldecode(<<-EOF
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: allow-person-service
      namespace: example
    spec:
      podSelector: {}
      policyTypes:
        - Ingress
      ingress:
        - from:
            - namespaceSelector:
                matchLabels:
                  name: example
              podSelector:
                matchLabels:
                  app: person-service-application
    EOF
  )
}