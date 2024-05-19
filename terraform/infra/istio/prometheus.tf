resource "terraform_data" "prometheus" {
  depends_on = [helm_release.kiali]
  provisioner "local-exec" {
    when = create
    command = "kubectl apply -f ./templates/prometheus.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ./templates/prometheus.yaml"
  }
}
