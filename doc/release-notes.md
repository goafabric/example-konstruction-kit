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