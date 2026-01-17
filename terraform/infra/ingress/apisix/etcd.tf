resource "helm_release" "apisix-etcd" {
  name       = "apisix-etcd"
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "etcd"
  namespace  = "ingress-apisix"
  version    = "0.4.0"
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

resource "terraform_data" "remove_etc_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc data-apisix-etcd-0 -n ingress-apisix; kubectl delete pvc data-apisix-etcd-1 -n ingress-apisix; kubectl delete pvc data-apisix-etcd-2 -n ingress-apisix"
  }
}