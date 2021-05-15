#0.8
##modified
- extracted to own GIT repo
- DEV Profile removed due to security reasons, just use ingress or ./stack proxy instead
- x-forwarded-prefix + server.forward-headers-strategy=FRAMEWORK removed, welcome board now only just shows health endpoint
- dynamic configmap creation removed

##added
- HTTPS for all Services via Ingress
- Istio as Addon including:
    - mTLS, dist Tracing via Jaeger, JVM Dashboards in Kiali, Possibility for CB
- Mod Security in passive mode (log only)
- Nginx Server Version Hiding works, where standard nginx-controller is used
- Dashboard Metrics Server

#0.4
- initial release