resource "kubernetes_network_policy" "allow_ingress_and_self" {
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
            name = "ingress-apisix"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            name = "core"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_person_service" {
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