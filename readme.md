#Prerequisites
- For specific installation instructions concerning linux and mac please see doc/install
- For local installations you need an entry in /etc/hosts like "127.0.0.1 kubernetes"
- For https to work you need to import src/deploy/kubernetes/infra/03_certificate/root/config/root.pem

#Installation
- Go to "src/deploy/kubernetes/infra"
- ./stack init
- You might be asked for
  - credentials
  - server name (for local installations just kubernetes)
  - the certificate password (also kubernetes)

#Welcome
- And that's basically it just navigate to http(s)://kubernetes/welcome and you see the Welcome Page
- Password is currently just admin/admin

#Examples
- To start specific applications change to the folder representing the namespace (e.g. src/deploy/kubernetes/example)
- And do "./stack up && ./stack import"
- To shut everything down do "./stack down"

#Proxy
- In case you need a localhost direct connection to your pod do "./stack proxy" (e.g. connecting with a frontend)
- "./stack jmx" or "./stack profile" will give you the options to profile the app

#Uninstall
- Go to "src/deploy/kubernetes/infra"
- ./stack prune-force => this will eradicate everything
- Note: More complex Addons like Istio or Linkerd should be uninstalled manually via ./stack prune inside there addon dirs