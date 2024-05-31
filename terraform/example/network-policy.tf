resource "kubernetes_network_policy" "allow_ingress_and_self" {
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
            name = "ingress-apisix"
          }
        }
      }
      from {
        namespace_selector {
          match_labels = {
            name = "example"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}