resource "kubernetes_namespace" "event" {
  metadata {
    name = "event"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_network_policy" "allow_self_ingress_prometheus" {
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
            name = "event"
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

resource "kubernetes_network_policy" "allow_core" {
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
            name = "core"
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