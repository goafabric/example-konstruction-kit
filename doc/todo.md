# Ops
- Istio CB
- Networks Separation (https://gardener.cloud/documentation/guides/applications/network-isolation/, https://kubernetes.io/docs/concepts/services-networking/network-policies/, https://github.com/ahmetb/kubernetes-network-policy-recipes/blob/master/06-allow-traffic-from-a-namespace.md)
curl callee-service-application.example2:8080/actuator/health

# Security
- Keycloak (https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth)
- Certmanager for Certs (https://tinyurl.com/1wjhxz9m)
- Outbound SSL

# Ops
- Helm
- Elk

# Activated but needs further Investigation
- Hide Nginx version, by installing standard nginx-controller 0.44.0
- Mod Security https://awkwardferny.medium.com/enabling-modsecurity-in-the-kubernetes-ingress-nginx-controller-111f9c877998
- Postgres Statefulsets / Operator (https://github.com/CrunchyData/postgres-operator, https://medium.com/@suyashmohan/setting-up-postgresql-database-on-kubernetes-24a2a192e962, https://contentlab.io/postgresql-on-kubernetes/)

