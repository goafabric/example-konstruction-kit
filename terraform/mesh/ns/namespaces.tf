resource "kubernetes_namespace" "core_minimal" {
  count = var.profile == "minimal" ? 1 : 0
  metadata {
    name = "core"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "core_ambient" {
  count = var.profile == "ambient" ? 1 : 0
  metadata {
    name = "core"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "example_minimal" {
  count = var.profile == "minimal" ? 1 : 0
  metadata {
    name = "example"
    labels = {
      istio-injection = "enabled"
    }
  }
}


resource "kubernetes_namespace" "example_ambient" {
  count = var.profile == "ambient" ? 1 : 0
  metadata {
    name = "example"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}
