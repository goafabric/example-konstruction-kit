# Prerequisites
- For local installations you need an entry in /etc/hosts like "127.0.0.1 kind.local"
- Docker Desktop, Terraform and latest kubectl need to be installed, k9s is optional but might help
- For https to work you need to import the certificate from your browser's certificate warning
- Corporate Proxies usually need to be deactivated as they often block image downloading 

# Basic Installation
- Go to "/terraform/server/kind"
- ./stack init
- in .values you may choose between apsix or nginx, 
  - apisix also needs the oidc namespace installed (terraform apply inside infra/oidc) 

# Welcome
- And that's basically it just navigate to http(s)://kubernetes/welcome and you see the Welcome Page
- Password is currently just admin/admin

# Additional Modules
- Additional modules can the be installed with terraform by going into the specific terraform folder (e.g. terraform example)
- And then just execute terraform apply (default server is kind)

# Uninstall
- Go to "/terraform/server/kind"
- ./stack prune => this will eradicate everything

# Helm Specific (deprecated)
- To start specific applications change to the folder representing the namespace (e.g. helm/templates/example/spring)
- And do "./stack up"
- To shut everything down do "./stack down"
- In case you need a localhost direct connection to your pod do "./stack proxy" (e.g. connecting with a frontend)
