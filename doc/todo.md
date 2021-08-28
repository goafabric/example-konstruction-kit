# Istio
- Istio CB
- Networks Separation (https://gardener.cloud/documentation/guides/applications/network-isolation/, https://kubernetes.io/docs/concepts/services-networking/network-policies/, https://github.com/ahmetb/kubernetes-network-policy-recipes/blob/master/06-allow-traffic-from-a-namespace.md)

# Security
- Keycloak (https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth)
- Outbound SSL

# Activated but needs further Investigation
- Hide Nginx version
- Mod Security https://awkwardferny.medium.com/enabling-modsecurity-in-the-kubernetes-ingress-nginx-controller-111f9c877998
- Postgres Statefulsets / Operator (https://github.com/CrunchyData/postgres-operator, https://medium.com/@suyashmohan/setting-up-postgresql-database-on-kubernetes-24a2a192e962, https://contentlab.io/postgresql-on-kubernetes/)

#Ops
- Certmanager for Certs (https://tinyurl.com/1wjhxz9m)
- Upgrade to Microk8s 1.20+ (problem with NGINX Class that needs to be named "public")
- Helm