# documentation
https://docs.konghq.com/kubernetes-ingress-controller/latest/plugins/custom/

# configmap
kubectl create configmap kong-plugin-myheader --from-file=./plugin -n kong

# helm
set {
  name  = "plugins.configMaps[0].name"
  value = "kong-plugin-oidc" #"kong-plugin-myheader"
}
set {
  name  = "plugins.configMaps[0].pluginName"
  value = "oidc" #"myheader"
}
