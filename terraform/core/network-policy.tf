resource "kubernetes_namespace" "core" {
  metadata {
    name = "core"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_network_policy" "allow_self_ingress_prometheus" {
  metadata {
    name      = "allow-ingress"
    namespace = "core"
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "core"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            name = "ingress-apisix"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "istio-system"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "prometheus"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}
resource "kubernetes_network_policy" "allow_invoice" {
  metadata {
    name      = "allow-invoice"
    namespace = "core"
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "invoice"
          }
        }
        pod_selector {
          match_labels = {
            app = "invoice-process-application"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}