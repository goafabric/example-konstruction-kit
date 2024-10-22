resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "ingress-apisix" {
  metadata {
    name = "ingress-apisix"
     labels = {
       "istio-injection" = "enabled"
     }
  }
}

resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "dashboard"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
#     labels = {
#       "istio.io/dataplane-mode" = "ambient"
#     }
  }
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}