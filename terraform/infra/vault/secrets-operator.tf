resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  
  namespace  = "vault"
  repository = "https://charts.external-secrets.io"
  create_namespace = true
  version    = "v0.10.3"
}

#https://medium.com/@muppedaanvesh/a-hands-on-guide-to-kubernetes-external-secrets-operator-%EF%B8%8F-6e630c2da25e
#https://www.infracloud.io/blogs/kubernetes-secrets-hashicorp-vault/