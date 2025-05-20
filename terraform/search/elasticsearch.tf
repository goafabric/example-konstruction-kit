resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "elasticsearch"
  version    = "21.3.8"
  namespace  = "search"
  create_namespace = true

  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "master.masterOnly"
    value = false
  }

  set {
    name  = "master.replicaCount"
    value = 1 #2
  }

  set {
    name  = "data.replicaCount"
    value = 0 #2
  }

  set {
    name  = "coordinating.replicaCount"
    value = 0 #2
  }

  set {
    name  = "ingest.replicaCount"
    value = 0 #2
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=elasticsearc -n search"
  }
}

resource "kubernetes_manifest" "elasticsearch-ingress" {
  manifest   = yamldecode(<<-EOF
  kind: Ingress
  apiVersion: networking.k8s.io/v1
  metadata:
    name: elasticsearch-ingress
    namespace: search
    annotations:
      konghq.com/strip-path: 'true'
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
            - path: /elastic
              pathType: ImplementationSpecific
              backend:
                service:
                  name: elasticsearch
                  port:
                    number: 9200
  EOF
  )
}