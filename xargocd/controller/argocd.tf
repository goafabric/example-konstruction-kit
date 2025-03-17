resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "7.8.11"

  set {
    name  = "crds.keep"
    value = "false"
  }

#  set {
#    name  = "configs.cm.timeout.reconciliation"
#    value = "20s"
#  }


  set {
    name  = "configs.params.server\\.insecure"
    value = true
  }

  set {
    name  = "global.domain"
    value = var.hostname
  }

  set {
    name  = "configs.params.server\\.basehref"
    value = "/argocd"
  }

  set {
    name  = "notifications.cm.create"
    value = "false"
  }

  set {
    name  = "global.addPrometheusAnnotations"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
}


resource "kubernetes_manifest" "argocd-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: argocd-ingress
    namespace: argocd
    annotations:
      cert-manager.io/cluster-issuer: my-cluster-issuer
      konghq.com/strip-path: 'true'
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
            - path: /argocd
              pathType: ImplementationSpecific
              backend:
                service:
                  name: argocd-server
                  port:
                    number: 80
  EOF
  )
}