resource "helm_release" "kong" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  version          = "2.38.0"
  namespace        = "kong"
  timeout          = "120"
  create_namespace = true

  set {
   name  = "proxy.type"
   value = local.ingress_service_type
  }

  set {
    name  = "proxy.tls.nodePort"
    value = "32443"
  }
}

resource "terraform_data" "kong_crd" {
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml && kubectl apply -f ./templates/gateway-class.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml && kubectl delete -f ./templates/gateway-class.yaml"
  }
}

