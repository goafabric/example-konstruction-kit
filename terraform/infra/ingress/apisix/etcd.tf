resource "helm_release" "etcd" {
  name       = "etcd"
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "etcd"
  namespace  = "ingress-apisix"
  version    = "0.3.2"
  timeout = 60

  set {
    name  = "config.extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "config.extraEnvVars[0].value"
    value = "Europe/Berlin"
  }
  set {
    name  = "replicaCount"
    value = 3
  }
}