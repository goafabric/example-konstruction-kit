resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.13.1"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  set {
    name  = "extraArgs[0]"
    value = "--enable-certificate-owner-ref"
  }
}

resource "kubernetes_manifest" "cert-manager-issuer" {
  depends_on = [helm_release.cert-manager]

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
  depends_on = [helm_release.cert-manager]

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
