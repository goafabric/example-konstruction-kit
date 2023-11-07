# resource "kubernetes_manifest" "example" {
#   manifest = {
#     apiVersion = "v1"
#     kind      = "ConfigMap"
#     metadata = {
#       name = "test-config"
#       namespace = "default"
#     }
#     data = {
#       TZ       = "Europe/Berlin"
#       test     = "testdata"
#        hostname = var.hostname
#     }
#   }
# }


resource "kubernetes_manifest" "dashboard" {
  manifest   = yamldecode(
  <<-EOF
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: test-config
          namespace: default
        data:
          #application
          TZ: Europe/Berlin
          test: "testdata"
          hostname: ${var.hostname}
  EOF
  )
}