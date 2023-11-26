# todos

## terraform
- workspaces + hostname variable
- No dashboard in Prod via Conditional Deploy
- No Openapi in prod (springdoc.swagger-ui.path: "//", springdoc.api-docs.path: "//")

## terraform cont.
- standard helm charts for minio, postgres, jaeger 
- preconfigured keycloak with users, realm, standard helm chart
- apisix deployment including gateway definitions, switchable between ingress and apisix

## security
- terraform generated secrets injected in to helm charts, eventually vault (alternative: https://itnext.io/manage-auto-generated-secrets-in-your-helm-charts-5aee48ba6918)
- volume encryption
- RBAC
- 10 best practices: https://www.youtube.com/watch?app=desktop&v=oBf5lrmquYI&pp=ygUSI211dGlyYW9rdWJlcm5ldGVz

## application           
- JWT HTTP Interceptor Config (Token, Tenant, Vaadin)
