resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "metallb-system"
#  version    = "4.7.0"
  create_namespace = true
}

resource "terraform_data" "metallb_config" {
  depends_on = [helm_release.metallb]
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f ./templates/metallb.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates/metallb.yaml"
  }
}