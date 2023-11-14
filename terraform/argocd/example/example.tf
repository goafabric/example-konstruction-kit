resource "kubernetes_manifest" "callee-service-application" {
  manifest   = yamldecode(<<-EOF
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: callee-service-application
      namespace: argocd
      finalizers:
        - resources-finalizer.argocd.argoproj.io
    spec:
      project: default
      source:
        repoURL: ${var.helm_repository}
        targetRevision: refactoring
        path: helm/templates/example/spring/callee-service/application
        helm:
          parameters:
            - name: "ingress.hosts"
              value: "${var.hostname}"
            - name: "image.arch"
              value: "-native${var.server_arch}"
            - name: "replicaCount"
              value: "1"
      destination:
        server: https://kubernetes.default.svc
        namespace: example
      syncPolicy:
        automated: {}
        syncOptions:
          - CreateNamespace=true
    EOF
  )
}

#resource "kubernetes_manifest" "person-service-application" {
#  manifest   = yamldecode(<<-EOF
#    apiVersion: argoproj.io/v1alpha1
#    kind: Application
#    metadata:
#      name: person-service-application
#      namespace: argocd
#    spec:
#      project: default
#      source:
#        repoURL: ${var.helm_repository}
#        targetRevision: refactoring
#        path: helm/templates/example/spring/person-service/application
#        helm:
#          parameters:
#            - name: "ingress.hosts"
#              value: "${var.hostname}"
#            - name: "image.arch"
#              value: "-native${var.server_arch}"
#            - name: "replicaCount"
#              value: "1"
#      destination:
#        server: https://kubernetes.default.svc
#        namespace: example
#      syncPolicy:
#        automated: {}
#        syncOptions:
#          - CreateNamespace=true
#    EOF
#  )
#}
#
#resource "kubernetes_manifest" "person-service-postgres" {
#  manifest   = yamldecode(<<-EOF
#    apiVersion: argoproj.io/v1alpha1
#    kind: Application
#    metadata:
#      name: person-service-postgres
#      namespace: argocd
#    spec:
#      project: default
#      source:
#        repoURL: ${var.helm_repository}
#        targetRevision: refactoring
#        path: helm/templates/example/spring/person-service/postgres
#        helm:
#          parameters:
#            - name: "ingress.hosts"
#              value: "${var.hostname}"
#            - name: "image.arch"
#              value: "-native${var.server_arch}"
#            - name: "replicaCount"
#              value: "1"
#      destination:
#        server: https://kubernetes.default.svc
#        namespace: example
#      syncPolicy:
#        automated: {}
#        syncOptions:
#          - CreateNamespace=true
#    EOF
#  )
#}