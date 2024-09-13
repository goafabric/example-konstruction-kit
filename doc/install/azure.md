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
=> Not required per se, Application Containers also get deployed to System Nodepool

Network Policies
- Networking/Network Policy/Azure
                                                                                               
Public IP Address (after Cluster Created)
- Home/Public IP Addresses
- Select your "Kubernetes*" server from the list with the Resource Group matching your Server Name
=> This will ONLY show up after some deployments beeing done to the server
- Settings/Configuration/DNS name label (optional)




# retetrieve k8s config
- open cloud shell in browser
- az aks get-credentials --resource-group Development --name adam-eden
- cat .kube/config

# current changes !!
- changed dashboard deployment to "metrics-server.enabled=false", as there is alread one deployed
- oidc_enabled = false set for now
- kong standard image, as the custom with oidc is currently arm only 

- fix for apisix routes as having just "headers:" without any header, fails on azure with "\n" errors
 
# todos
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
