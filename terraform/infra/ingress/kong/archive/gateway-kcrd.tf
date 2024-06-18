resource "terraform_data" "gateway_crd" {
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml && kubectl apply -f ./archive/gateway-class.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f ./archive/gateway-class.yaml && kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
  }
}