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
  
#Examples
- To start the example applications go to "src/deploy/kubernetes/example" and do ./stack up && ./stack import

#Welcome
- And that's basically it just navigate to http(s)://kubernetes/welcome and you see the Welcome Page
- Password is currently just admin/admin 

#Uninstall
- Go to "src/deploy/kubernetes/infra"
- ./stack prune-force => this will eradicate everything