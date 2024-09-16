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
            "kubernetes.io/metadata.name" = "core"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "ingress-apisix"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "apisix"
          }
        }
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kong"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "kong"
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
            "kubernetes.io/metadata.name" = "invoice"
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