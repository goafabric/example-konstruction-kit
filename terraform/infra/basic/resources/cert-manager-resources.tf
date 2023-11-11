resource "kubernetes_manifest" "cert-manager-issuer" {
  manifest   = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: my-cluster-issuer
    spec:
      selfSigned: {}
    EOF
  )
}

resource "kubernetes_manifest" "cert-manager-certificate" {
  manifest   = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: cluster-ca
      namespace: cert-manager
    spec:
      isCA: true

      commonName: ${var.hostname}
      dnsNames:
        - ${var.hostname}
      subject:
        organizations:
          - Example Organization

      secretName: root-certificate
      privateKey:
        algorithm: ECDSA
        size: 256
      issuerRef:
        name: my-cluster-issuer
        kind: ClusterIssuer
        group: cert-manager.io
      EOF
  )
}
