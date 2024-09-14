resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "core" {
  metadata {
    name = "core"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "event" {
  metadata {
    name = "event"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "invoice" {
  metadata {
    name = "invoice"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}