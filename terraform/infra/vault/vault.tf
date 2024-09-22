resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  namespace  = "vault"
  repository = "https://helm.releases.hashicorp.com"
  create_namespace = true
  version    = "0.28.1"

  set {
    name  = "server.ha.enabled"
    value = "false"
  }

  set {
    name  = "server.dev.enabled"
    value = "true"
  }

}

resource "terraform_data" "create_stack" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    when    = create
    command = "./stack up"
  }
}

resource "terraform_data" "destroy_stack" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    when    = destroy
    command = "delete -f ./example-apps/deployment.yaml -n example"
  }
}