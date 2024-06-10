resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

resource "kubernetes_network_policy" "allow_self_ingress_prometheus" {
  metadata {
    name      = "allow-ingress"
    namespace = "example"
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "example"
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