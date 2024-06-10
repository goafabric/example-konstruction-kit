resource "helm_release" "redis" {
  repository = var.helm_repository
  name       = "redis-master"
  chart      = "${var.helm_repository}/invoice-process/redis"
  namespace  = "invoice"
  create_namespace = true
  timeout = var.helm_timeout
}


# resource "helm_release" "redis" {
#   name       = "redis"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "redis"
#   namespace  = "invoice"
#   version    = "19.5.2"
#
#   set {
#     name  = "master.persistence.size"
#     value = "2Gi"
#   }
#   set {
#     name  = "replica.persistence.size"
#     value = "2Gi"
#   }
#   set {
#     name  = "architecture"
#     value = "standalone"
#   }
#   set {
#     name  = "auth.enabled"
#     value = false
#   }
#   set {
#     name  = "networkPolicy.enabled"
#     value = false
#   }
#
# }
#
# resource "terraform_data" "remove_redis_pvc" {
#   provisioner "local-exec" {
#     when    = destroy
#     command = "kubectl delete pvc -l app.kubernetes.io/instance=redis -n invoice"
#   }
# }