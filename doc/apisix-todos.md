# Core Helm charts
- Looks good, Core works, Tenant works, also Examples work
- route.yml is mostly understandable except for helm templating mechanism

- are alle the oidc parameters needed | can they be extracted? (set_id, set_userinfo ..)
- also client_secret is in clear text and not stored as a secret
- Cookie and Local Storage needs be be erased once, or Error 500

# Infrastructure
- Apisix Controller consumes 450MB vs < 200 to NGINX, are 3 etcd needed ?
- With Opentelemetry enabled but not configured, no route will be created
- apisix helm chart should have a fixed version like 2.3.0

# OIDC stream to big error
- happens if already authentication to one service (e.g. core) than opening another one (e.g. catalog)
- with nginx we could easily set this to keycloak ingress => nginx.ingress.kubernetes.io/proxy-buffer-size: 10k
- with apisix seems more compilcated https://github.com/apache/apisix/issues/4162

# microk8s loadbalancer
- we need to activate a lb, otherweise lb external ip will not become available "microk8s enable metallb"
- ip range needs to be set to you server ip from dns, e.g: 45.129.180.184-45.129.180.184 

