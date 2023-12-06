resource "terraform_data" "ingress-nginx" {
  depends_on = [kind_cluster.kind]
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
  }
}



