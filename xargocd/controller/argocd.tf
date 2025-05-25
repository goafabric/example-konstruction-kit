resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "8.0.9"

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
  set {
    name  = "dex.enabled"
    value = "false"
  }

}


resource "kubernetes_manifest" "argocd-ingress" {
  depends_on = [helm_release.argocd]
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

resource "kubernetes_manifest" "argocd-route" {
  manifest   = yamldecode(<<-EOF
  kind: ApisixRoute
  apiVersion: apisix.apache.org/v2
  metadata:
    name: argocd
    namespace: argocd
  spec:
    http:
      - name: argocd
        match:
          hosts:
            - ${var.hostname}
          paths:
            - /argocd
            - /argocd/*
        backends:
          - serviceName: argocd-server
            servicePort: 80
        plugins:
          - name: redirect
            enable: true
            config:
              http_to_https: true
          - name: proxy-rewrite
            enable: true
            config:
              regex_uri:
                - /argocd/(.*)
                - /$1
  EOF
  )
}