# links 
https://portal.azure.com/#home
https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli
  
# retetrieve k8s config
- open cloud shell in browser
- az aks get-credentials --resource-group Development --name myaks
- cat .kube/config
                
# current changes
- disabled dashboard deployment due to helm error
- kong standard image, as the custom with oidc is currently arm only 

