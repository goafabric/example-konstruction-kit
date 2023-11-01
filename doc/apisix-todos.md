# cleanup
- apisix extra files like routing or tls configuration should be installed simple by a single file with kubectl 
  - files can then be put additionaly inside the deployment automation, every extra file will polute that structure
- there should be no hardcoded secrets (e.g. odic configuration) outside secret.yaml or better secrets created on the fly
- are alle the oidc parameters needed | can they be extracted? (set_id, set_userinfo ..)

- fix etcd crashloop problem

# microk8s loadbalancer
- we need to activate a lb, otherweise lb external ip will not become available "microk8s enable metallb"
- ip range needs to be set to you server ip from dns, e.g: 45.129.180.184-45.129.180.184 

