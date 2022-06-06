#1.0.1
- welcome board nginx upgrade to 1.20.2
- upgrade to istio 1.14.0 + kiali 1.50.0

#1.0.0
- upgrade to Keycloak 18.0.0
- upgrade to istio 1.13.3
- upgrade to nginx-controller 1.2.0
- upgrade to kubernetes-dashboard 2.5.1

#0.9.3
- infra structure changes
- upgrade to istio 1.13.2, kiali 1.47.0
- upgrade to jaeger 1.32.0
- upgrade to OauthProxy 7.2.1, Keycloak 17.0.1
- upgrade of all Service Versions to latest Spring / Quarkus versions + OauthProxy Support

#0.9.2
- update to kubernetes-dashboard 2.5.0
- trust store added
- configurable ingress authentication added
- disabled helm binary and PING test for Windows Compatibility

#0.9.1
- fixes for oidc / keycloak

#0.9.0
- migration to helm charts
- upgrade of person-service and callee-service to 1.2.0
- upgrade to istio 1.12.1
- compatibility with Kubernetes 1.22

#0.8.8
- upgrade of kubernetes dashboard and metrics servers
- upgrade tp nginx controller 1.0.4
- upgrade to istio 1.11.4
- oidc possibility via ouauth2-proxy added
- upgrade to Postgres 14.0

#0.8.7
- Upgrade all versions to 1.1.0+
- Istio: Circuitbreaker and Namespace Isolation added
- Upgrade to Postgres 13.4

#0.8.6
- extra namespace for monitoring, includes loki and jaeger
- restructuring of quarkus and spring directories
- postgres 13.3 update
- CalleeService Upgrade to 1.0.8

#0.8.5
- jaeger added to multiple services
- person-service upgrade to 1.0.6
- loki added

#0.8.4
- fhir facade quarkus added

#0.8.3
- upgrade to latest person-service 1.0.5 and callee-service 1.0.7

#0.8.2
- upgrade to istio 1.10
- multi tenancy examples added

#0.8.1
- changes to Istio
- Added PersonService and CalleeService as a Replacement for Exampleservice, as Spring and Quarkus Stack

#0.8
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

#0.4
- initial release