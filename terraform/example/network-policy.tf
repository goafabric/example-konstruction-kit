resource "kubernetes_network_policy" "allow_ingress" {
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
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_person_service" {
  metadata {
    name      = "allow-person-service"
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
        pod_selector {
          match_labels = {
            app = "person-service-application"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}