resource "kubernetes_network_policy" "allow_self_ingress_prometheus_event" {
  metadata {
    name      = "allow-ingress"
    namespace = "event"
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "event"
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

resource "kubernetes_network_policy" "allow_core_event" {
  metadata {
    name      = "allow-core"
    namespace = "event"
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
        pod_selector {
          match_labels = {
            app = "core-application"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}