resource "kubernetes_deployment" "localstack" {
  metadata {
    name = "localstack"
    labels = {
      app = "localstack"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "localstack"
      }
    }

    template {
      metadata {
        labels = {
          app = "localstack"
        }
      }

      spec {
        container {
          name  = "localstack"
          image = "localstack/localstack:4.2.0"

          port {
            container_port = 4566
          }

          env {
            name  = "AWS_DEFAULT_REGION"
            value = "eu-central-1"  
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "localstack" {
  metadata {
    name = "localstack"
  }

  spec {
    selector = {
      app = "localstack"
    }

    port {
      protocol    = "TCP"
      port        = 4566
      target_port = 4566
      node_port   = 30566  # NodePort must be in the range 30000-32767
    }

    type = "NodePort"
  }
}
