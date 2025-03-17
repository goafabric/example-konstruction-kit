resource "kubernetes_network_policy" "allow_self_ingress_prometheus_invoice" {
  metadata {
    name      = "allow-ingress"
    namespace = "invoice"
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