resource "kubernetes_network_policy" "allow_ingress_and_self" {
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
            name = "ingress-apisix"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            name = "invoice"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}