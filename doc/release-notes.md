# 1.3.7
- upgrade Kind to Kubernetes 1.32 
- upgrade of Spring Applications to 3.4.3

# 1.3.6
- upgrade to Istio 1.24.2 
- upgrade to Kiali 2.3.0
- upgrade to Prometheus Chart 25.27.0
- upgrade to Postgres 17.2
- upgrade to Kafka Chart 31.0.0
- multi tenancy handling added
- Azure Server Handling added 

# 1.3.5
- Compatibility with Azure
- Nats removed
- Kafka added directly to core Service
- upgraded Apps to version 3.3.3

- upgrade to Apisix to chart 2.9.0
- upgrade to Istio 1.23.1 
- upgrade to Postgres 16.4
- upgrade to Cert Manager 1.15.3
- upgrade to Redis Chart 20.1.1
- upgrade to Kafka Chart 30.1.
- upgrade to Kong 3.8.0
- upgrdae to Grafana 8.x

- upgrade Kind to Kubernetes 1.31 that supports network policies, currently needs workaround scale down DNS

- compatibility of Apisix with Istio, via Mixed Mode and Host Name Fix

# 1.3.4
- back to stable invoice release
- Tech Radar added
- Nats added

# 1.3.3
- kong oidc integration
- autoscaler integration
- k6 loadtests added

# 1.3.2
- cleanup of event folder
- network policies added
- basic auth to core service added
- kiali connection to tempo tracing added, spring application name now contains the Namespace
- upgrade to apisix chart 2.8.0
- upgrade to kind kubernetes 1.3.0
- upgrade to kubernetes dashboard 6.0.8 (7.x has a lot of breaking changes)
- Namespaces are now created ahead of time during initial install
- moved dashboard to dashboard namespace
- moved everything grafana to grafana namespace
- added redis cluster to invoice

# 1.3.1
- switchable kafka and rabbitmq broker added

# 1.3.0
- kong gateway definitions added
- nginx controller removed
- namespace message-broker renamed to event, kafka is now also the default
- moved welcome page from default to monitoring namespace, due to cert problems
- fixed an issue with apisix oidc reauthentication happening on root url switch (session.secret)
- upgraded examples to version 3.3.0

# 1.2.4
- upgrade to Apisix Chart 2.7.0
- added kong gateway as an option

# 1.2.3
- switchable apisix authentication
- quarkus reintroduced
- dangerous helm secret defaults removed
- quarkus otel fixes for tempo

# 1.2.2
- fix for manual helm chart rollout

# 1.2.1
- upgrade of all service applications
- apisix including authentication added
- kind initial rollout fixed

# 1.2.0
- terraform variable optimization
- helm charts dir removed
- massive refactoring of directories
- upgrade of ingress nginx helm chart to 4.10.0
- upgrade of cert-manager helm chart to 1.14.4
- added grafana tempo + update of other grafana components to latest version in monolithic mode

# 1.1.1
- terraform added
- argocd added
- removed Chart.AppVersion from selectorLabels as it whoed with update

- openapi endpoints blocked due to security reasons
- conditional deploy for dashboard only for dev stages
- postgres upgrade to 16.1

- tons of other changes

# 1.1.0
- cert-manager added
- loki updated and working again
- upgrade to core 1.0.5
- upgrade to minio RELEASE.2023-08-23
- postgres upgrade to 16.0
- fixes and apisix preparations

# 1.0.7
- upgrade to kubed 0.13.2
- upgrade to istio 1.16.2 + kiali 1.63.0
- upgrade of postgres to 16.1
- upgrade of keycloak to 20.0.2
- verify linkerd 2.12.4

- upgrade of spring apps to 3.0.3

- rabbitmq removed
- keycloak endpoint changed to /oidc
- batch applications temp. disabled
- spring authorization server added

# 1.0.6
- upgrade to Keycloak 19.0.2
- upgrade to Oauth Proxy 7.4.0
- helm charts repository via github pages

# 1.0.5
- upgrade to istio 1.16.1 + kiali 1.59.0
- upgrade to Jaeger 1.39.0
- upgrade to kubernetes-dashboard 2.7.0
- upgrade to postgres 14.5

- upgrade of all Spring Services to 3.0.0
- upgrade of all Quarkus Services to 2.0.2

# 1.0.4
- compatibility with linkerd 2.12
- compatibility with kubernetes 1.25

# 1.0.3
- all example services upgraded to latest 2.0.0

- upgrade to Keycloak 19.0.0
- upgrade to OauthProxy 7.3.0
- upgrade to Jaeger 1.37.0
- upgrade to istio 1.14.3 + kiali 1.54.0

# 1.0.1
- welcome board nginx upgrade to 1.20.2
- upgrade to istio 1.14.1 + kiali 1.51.0
- upgrade to jaeger 1.36.0
- upgrade to nginx controller 1.3.0
- upgrade to rabbitmq 3.10.6
- upgrade to postgres 14.5
- upgrade to Keycloak 18.0.2
- upgrade to kubernetes-dashboard 2.6.0
- oidc auth switch added + script fixes

- all example services upgraded to latest 1.3.0

# 1.0.0
- upgrade to Keycloak 18.0.0
- upgrade to istio 1.13.3
- upgrade to nginx-controller 1.2.0
- upgrade to kubernetes-dashboard 2.5.1

# 0.9.3
- infra structure changes
- upgrade to istio 1.13.2, kiali 1.47.0
- upgrade to jaeger 1.32.0
- upgrade to OauthProxy 7.2.1, Keycloak 17.0.1
- upgrade of all Service Versions to latest Spring / Quarkus versions + OauthProxy Support

# 0.9.2
- update to kubernetes-dashboard 2.5.0
- trust store added
- configurable ingress authentication added
- disabled helm binary and PING test for Windows Compatibility

# 0.9.1
- fixes for oidc / keycloak

# 0.9.0
- migration to helm charts
- upgrade of person-service and callee-service to 1.2.0
- upgrade to istio 1.12.1
- compatibility with Kubernetes 1.22

# 0.8.8
- upgrade of kubernetes dashboard and metrics servers
- upgrade tp nginx controller 1.0.4
- upgrade to istio 1.11.4
- oidc possibility via ouauth2-proxy added
- upgrade to Postgres 14.0

# 0.8.7
- Upgrade all versions to 1.1.1+
- Istio: Circuitbreaker and Namespace Isolation added
- Upgrade to Postgres 13.4

# 0.8.6
- extra namespace for monitoring, includes loki and jaeger
- restructuring of quarkus and spring directories
- postgres 13.3 update
- CalleeService Upgrade to 1.0.8

# 0.8.5
- jaeger added to multiple services
- person-service upgrade to 1.0.6
- loki added

# 0.8.4
- fhir facade quarkus added

# 0.8.3
- upgrade to latest person-service 1.0.6 and callee-service 1.0.8

# 0.8.2
- upgrade to istio 1.10
- multi tenancy examples added

# 0.8.1
- changes to Istio
- Added PersonService and CalleeService as a Replacement for Exampleservice, as Spring and Quarkus Stack

# 0.8
##modified
- DEV Profile removed due to security reasons, just use ingress or ./stack proxy instead
- x-forwarded-prefix + server.forward-headers-strategy=FRAMEWORK removed, welcome board now only just shows health endpoint
- dynamic configmap creation removed

##added
- HTTPS for all Services via Ingress
- Istio as Addon including:
    - mTLS, dist Tracing via Jaeger, JVM Dashboards in Kiali, Possibility for CB
- Mod Security in passive mode (log only)
- Nginx Server Version Hiding works, where standard nginx-controller is used

# 0.4
- initial release