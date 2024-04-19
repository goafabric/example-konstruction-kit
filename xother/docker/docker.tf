terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "callee-service" {
  name = "goafabric/callee-service:3.2.0"
}

# Create a container
resource "docker_container" "foo" {
  image = docker_image.callee-service.image_id
  name  = "foo"
}