# todos

## terraform
- workspaces + hostname variable

## terraform cont.
- standard helm charts for minio, postgres, jaeger 
- preconfigured keycloak with users, realm, standard helm chart
- apisix deployment including gateway definitions, switchable between ingress and apisix
- grafana oss with loki + tempo

## security
- terraform generated secrets injected in to helm charts, eventually vault (alternative: https://itnext.io/manage-auto-generated-secrets-in-your-helm-charts-5aee48ba6918)
- volume encryption
- RBAC
- 10 best practices: https://www.youtube.com/watch?app=desktop&v=oBf5lrmquYI&pp=ygUSI211dGlyYW9rdWJlcm5ldGVz
- CSP Headers for Ingress that satisfy Owasp Zap (seems to need restat after every scan)

## application           
- JWT HTTP Interceptor Config (Token, Tenant, Vaadin)
