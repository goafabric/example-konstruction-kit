# links 
https://portal.azure.com/#home
https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli
  
# retetrieve k8s config
- open cloud shell in browser
- az aks get-credentials --resource-group Development --name myaks
- cat .kube/config

# cluster config workaround                         
- kubectl create configmap cluster-config -n default --from-literal=hostname=$TF_VAR_hostname

# current changes
- disabled dashboard deployment due to helm error
- kong standard image, as the custom with oidc is currently arm only 

          
# todos
- external DNS for web Access (not kube API) is missing, so apisix routes cannot match the host
  - => removing the host field does not seem to work
- access and provision server via azure cli / later terraform
- keep cost under control