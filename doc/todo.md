# Ops
- Istio CB
- Linkerd 2.10
- Networks Seperation (https://gardener.cloud/documentation/guides/applications/network-isolation/)

# Security
- Keycloak (https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth)
- Certmanager for Certs (https://tinyurl.com/1wjhxz9m)
- Outbound SSL

# Ops
- Helm
- Monitoring (Elk, Prometheus, Graphana ...)

#Ingress
- Hide Nginx version, by installing standard nginx-controller 0.44.0
  
# Activated but needs further Investigation
- Mod Security https://awkwardferny.medium.com/enabling-modsecurity-in-the-kubernetes-ingress-nginx-controller-111f9c877998
- Postgres Statefulsets / Operator (https://github.com/CrunchyData/postgres-operator, https://medium.com/@suyashmohan/setting-up-postgresql-database-on-kubernetes-24a2a192e962, https://contentlab.io/postgresql-on-kubernetes/)
- Jaeger as library (https://softwarehandwerk.com/distributed-tracing-mit-spring-cloud-sleuth-und-jaeger-auf-openshift/)