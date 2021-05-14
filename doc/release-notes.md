#1.0.5
##modified
- extracted to own GIT repo
- DEV Profile removed due to security reasons, just use ingress or ./stack proxy instead
- x-forwarded-prefix + server.forward-headers-strategy=FRAMEWORK removed, welcome board now only just shows health endpoint
- dynamic configmap creation removed

##added
- Istio and linkerd now as addons inside 06_addons
- This includes dist tracing via Jaeger, JVM Dashboards in Kiali, Possibility for CB