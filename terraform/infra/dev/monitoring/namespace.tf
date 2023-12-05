# for whatever stupid reason, nginx ingress also needs the secret here, if if only used inside monitoring ns
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
