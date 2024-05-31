resource "kubernetes_network_policy" "allow_ingress_and_self" {
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
            name = "ingress-apisix"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            name = "event"
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