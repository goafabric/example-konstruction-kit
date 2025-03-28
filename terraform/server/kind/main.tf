terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.8.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "kind" {
  name           = "kind"
  wait_for_ready = false

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 32443
        host_port      = 443
      }
      extra_port_mappings {
        container_port = 30800
        host_port      = 30800
      }

      extra_port_mappings {
        container_port = 30566
        host_port      = 4566
      }


    }

#    node {
#      role = "worker"
#    }
  }
}

resource "terraform_data" "docker_restart" {
  depends_on = [kind_cluster.kind]
  provisioner "local-exec" {
    when    = create
    command = "docker update --restart=no kind-control-plane"
  }
}