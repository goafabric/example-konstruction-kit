provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

resource "helm_release" "callee-service" {
  name       = "callee-service"

  repository = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
  chart      = "callee-service-application"
  version    = "1.1.1"
  namespace  = "example"
  create_namespace = true

  set {
    name  = "ingress.hosts"
    value = "kubernetes"
  }

  set {
    name  = "image-arch"
    value = "-native"
  }

}