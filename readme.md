# Prerequisites
- For specific installation instructions concerning linux and mac please see doc/install
- Easiest Option is recent version of Docker Dekstop + Kubernetes 1.25+ enabled

- For local installations you need an entry in /etc/hosts like "127.0.0.1 kubernetes"
- For https to work you need to import helm/templates/infra/infra/certificate/root/config/root.pem
- You need a Helm3 command line tool, as well as kubectl if not provided by your Kubernetes System
- However if helm cannot be found the installer will try to install it for you
 
# Quickstart
curl -LJO https://raw.githubusercontent.com/goafabric/example-konstruction-kit/refactoring/helm/templates/infra/installer && chmod +x ./installer && ./installer init

# Installation
- Obselete if Quickstart was executed
- Go to "helm/templates/infra"
- ./installer init
- You might be asked for
  - credentials
  - server name (for local installations just kubernetes)
  - the certificate password (also kubernetes)

# Welcome
- ./installer welcome will give you a welcome page
- Password is currently just admin/admin

# Examples
- To start specific applications change to the folder representing the namespace (e.g. helm/templates/example/spring)
- And do "./stack up" 
- To shut everything down do "./stack down"

# Proxy
- In case you need a localhost direct connection to your pod do "./stack proxy" (e.g. connecting with a frontend)

# Uninstall
- ./installer prune => this will eradicate everything
- Note: More complex Addons like Istio or Linkerd should be uninstalled manually via ./stack init inside the addon dirs

# Dashboard Troubleshoot
- If the dashboard cannot by downloaded due to company proxies, please issue a manual "docker pull kubernetesui/dashboard:v2.7.0"