resource "kubernetes_labels" "core_minimal" {
  count = var.profile == "minimal" ? 1 : 0
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "core"
  }
  labels = {
    istio-injection = "enabled"
  }
}

resource "kubernetes_labels" "core_ambient" {
  count = var.profile == "ambient" ? 1 : 0
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "core"
  }
  labels = {
    "istio.io/dataplane-mode" = "ambient"
  }
}

resource "kubernetes_labels" "example_minimal" {
  count = var.profile == "minimal" ? 1 : 0
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "example"
  }
  labels = {
    istio-injection = "enabled"
  }
}

resource "kubernetes_labels" "example_ambient" {
  count = var.profile == "ambient" ? 1 : 0
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "example"
  }
  labels = {
    "istio.io/dataplane-mode" = "ambient"
  }
}

#resource "kubernetes_labels" "message_broker_minimal" {
#  count = var.profile == "minimal" ? 1 : 0
#  api_version = "v1"
#  kind        = "Namespace"
#  metadata {
#    name = "event"
#  }
#  labels = {
#    istio-injection = "enabled"
#  }
#}
#

#resource "kubernetes_labels" "message_broker_ambient" {
#  count = var.profile == "ambient" ? 1 : 0
#  api_version = "v1"
#  kind        = "Namespace"
#  metadata {
#    name = "event"
#  }
#  labels = {
#    "istio.io/dataplane-mode" = "ambient"
#  }
#}
#
#resource "kubernetes_labels" "ingress_nginx_ambient" {
#  count = var.profile == "ambient" ? 1 : 0
#  api_version = "v1"
#  kind        = "Namespace"
#  metadata {
#    name = "ingress-nginx"
#  }
#  labels = {
#    "istio.io/dataplane-mode" = "ambient"
#  }
#}
