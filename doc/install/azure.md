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
=> This will ONLY show up after an ingress controller with loadbalancer usages is deployed, it will also get removed upon undeployment !
- Settings/Configuration/DNS name label (optional)

# retetrieve k8s config
- open cloud shell in browser
- az aks get-credentials --resource-group Development --name xxx
- cat .kube/config

# C5 (optional)
- Redundancy Model (Multiple Nodes, Multiple Zones)
- HashiCorp Vault vs Azure Vault
- Data Backup => Azure solution ?
- Volume Encryption: Enabled by Default

- Network Policies, Apisix, Cert Manager via Helm ?
- Grafana: Managed solution vs Helm ?
                                        
# managed postgres
- NAME: Azure Database for PostgreSQL Flexible Server
- costs 
  - start at 30 euros per month, for the cheapest 1 core machine
  - a more production ready 4 core 250 euros per month
  - replicas are not available, instead hot standby that will just cost the same amount on top
- access
  - network access can be set to public at the beginning by granting public IPS via Firewall
      - including Option "Allow public access from any Azure service within Azure to this server"
  - could be changed later to private Network
  - jdbc connection needs to be at least configured with /postgres?sslmode=require
  - better is /postgres?sslmode=verify-full
    - this needs the azure root certificate to be download and installed in AKS, either via ConfigMap or Vault Config

# managed blob storage
- NAME Storage Account, covers multiple things
- blob storage is found under "containers"
- costs
  - costs are not very evident, but seems to be cheap
- access 
  - should be anonymous
  - api is not s3 compatible, proxy solutions are not recommend as possible bottlneck and expensive (400 euros per month)
  - recommended way via azure SDK and feature toggle between AWS + Azure
    - needs account name and account key as config parameters, can be found under "Security + Networking/Access Keys"

# kafka / event hub
- create event hub with the standard 22$ tier
- retrieve connection string from settings\Shared Access Policies\RootManageSharedAccessKey
- spring boot config
```yaml
spring:
  kafka:
    bootstrap-servers: "<namespace-name>.servicebus.windows.net:9093"
    properties:
      security.protocol: SASL_SSL
      sasl.mechanism: PLAIN
      sasl.jaas.config: >
        org.apache.kafka.common.security.plain.PlainLoginModule required
        username="$ConnectionString"
        password="Endpoint=sb://<namespace-name>.servicebus.windows.net/;SharedAccessKeyName=<policy-name>;SharedAccessKey=<access-key>";
    admin:
      auto-create-topics: true
```
