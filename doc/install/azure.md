# links 
https://portal.azure.com/#home
https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli
   
# costs       
- All Services/Subscriptions => should be watched all of the time

# create cluster
- Kubernetes Services / Create / Kubernetes Cluster

Basics
- Cluster Preset: Dev/Test
- Pricing tier: Free
- Region: (Europe) West Europe

Node Pools
- Add Node Pool
- Node Size: D2s_v3 (2 CPU 8 GB) : 70$ per Month
- Min Node Count: 1 / Maximum Node Count : 1

=> This will create a User Nodepool with a Single node, System Nodepool will also be automatically attached

# retetrieve k8s config
- open cloud shell in browser
- az aks get-credentials --resource-group Development --name myaks
- cat .kube/config

# current changes !!
- disabled dashboard deployment due to helm error
- oidc_enabled = false set for now
- kong standard image, as the custom with oidc is currently arm only 
- callee-service changed to loadbalancer deployment with external ip
 
# todos
- 1st start with example-konstruktion kit
- 2nd move to real konstruktion kit

- external DNS for web Access (not kube API) is missing, so apisix routes cannot match the host
  - => removing the host field does not seem to work
  - current workaround using external specific IP and type loadbalancer (see callee-service, values.yaml)
- access and provision server via azure cli / later terraform

# cluster config workaround
- kubectl create configmap cluster-config -n default --from-literal=hostname=$TF_VAR_hostname

# C5 (optional)
- Redundancy Model (Multiple Nodes, Multiple Zones)
- HashiCorp Vault vs Azure Vault
- Data Backup => Azure solution ?
- Volume Encryption: Enabled by Default


- Network Policies, Apisix, Cert Manager via Helm ?
- Grafana: Managed solution vs Helm ?
