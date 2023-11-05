resource "helm_release" "s3-minio" {
  repository = var.example_repository
  name       = "s3-minio"
  chart      = "s3-minio"
  version    = "1.1.1"
  namespace  = "core"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
}