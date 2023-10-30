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