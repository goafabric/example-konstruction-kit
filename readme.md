#Prerequisites
- For specific installation instructions concerning linux and mac please see doc/install
- For local installations you need an entry in /etc/hosts like "127.0.0.1 kubernetes"
- For https to work you need to import helm/templates/infra/infra/03_certificate/root/config/root.pem
- You need a Helm3 command line tool, as well as kubectl if not provided by your Kubernetes System

#Installation
- Go to "helm/templates/infra"
- ./stack init
- You might be asked for
  - credentials
  - server name (for local installations just kubernetes)
  - the certificate password (also kubernetes)

#Welcome
- And that's basically it just navigate to http(s)://kubernetes/welcome and you see the Welcome Page
- Password is currently just admin/admin

#Examples
- To start specific applications change to the folder representing the namespace (e.g. helm/templates/example)
- And do "./stack up" 
- To shut everything down do "./stack down"

#Proxy
- In case you need a localhost direct connection to your pod do "./stack proxy" (e.g. connecting with a frontend)
- "./stack jmx" or "./stack profile" will give you the options to profile the app

#Uninstall
- Go to "helm/templates/infra"
- ./stack prune-force => this will eradicate everything
- Note: More complex Addons like Istio or Linkerd should be uninstalled manually via ./stack prune inside there addon dirs