resource "kubernetes_network_policy" "allow_self_ingress_prometheus_data" {
  metadata {
    name      = "allow-ingress"
    namespace = "data"
  }

  spec {
    pod_selector {}
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "data"
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


resource "kubernetes_network_policy" "allow_core_data" {
  metadata {
    name      = "allow-core-data"
    namespace = "data"
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
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "core"
          }
        }
        pod_selector {
          match_labels = {
            app = "catalog-application"
          }
        }
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "core"
          }
        }
        pod_selector {
          match_labels = {
            app = "catalog-batch"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "core"
          }
        }
        pod_selector {
          match_labels = {
            app = "core-provisioning"
          }
        }
      }

      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "example"
          }
        }
        pod_selector {
          match_labels = {
            app = "person-service-provisioning"
          }
        }
      }


    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_core_event2" {
  metadata {
    name      = "allow-core-event"
    namespace = "data"
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
        pod_selector {
          match_labels = {
            app = "event-dispatcher-service-application"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_invoice_data" {
  metadata {
    name      = "allow-invoice"
    namespace = "data"
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