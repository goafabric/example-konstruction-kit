# Core Helm charts
- are alle the oidc parameters needed | can they be extracted? (set_id, set_userinfo ..)
- also client_secret is in clear text and not stored as a secret
- Cookie and Local Storage needs be be erased once, or Error 500

# Infrastructure
- Apisix Controller consumes 450MB vs < 200 to NGINX, are 3 etcd needed ?
- With Opentelemetry enabled but not configured, no route will be created
- apisix helm chart should have a fixed version like 2.3.0

# OIDC stream to big error
- happens if already authentication to one service (e.g. core) than opening another one (e.g. catalog)
- with nginx we could easily set this to keycloak ingress => nginx.ingress.kubernetes.io/proxy-buffer-size: 10k
- with apisix seems more compilcated https://github.com/apache/apisix/issues/4162

# microk8s loadbalancer
- we need to activate a lb, otherweise lb external ip will not become available "microk8s enable metallb"
- ip range needs to be set to you server ip from dns, e.g: 45.129.180.184-45.129.180.184 

#
#!/bin/bash
read -d '' configHttp << EOF
proxy_buffer_size 128k;
proxy_buffers 32 128k;
proxy_busy_buffers_size 128k;
EOF
read -d '' configServer << EOF
proxy_buffer_size 128k;
proxy_buffers 32 128k;
proxy_busy_buffers_size 128k;
EOF
_Values_host_name=`kubectl get configmaps cluster-config -o jsonpath='{.data.hostname}' -n default` && [ -z "$_Values_host_name" ] && echo "Server Name is empty" && exit
function dynKubectl() {
eval "cat <<EOF
$(<$2)
EOF
" | kubectl $1 -n $3 -f -
}
helm repo add apisix https://apache.github.io/apisix-helm-chart
helm repo update
helm install apisix apisix/apisix \
--set service.type=LoadBalancer,apisix.ssl.enabled=true,apisix.ssl.containerPort=443 \
--set-string podSecurityContext.sysctls\[0\].name=net.ipv4.ip_unprivileged_port_start \
--set-string podSecurityContext.sysctls\[0\].value=0 \
--set etcd.replicaCount=3 \
--set "apisix.plugins={opentelemetry,openid-connect,redirect,proxy-rewrite,basic-auth}" \
--set apisix.pluginAttrs.redirect.https_port=443 \
--set apisix.pluginAttrs.opentelemetry.resource.service.name=APISIX \
--set apisix.pluginAttrs.opentelemetry.collector.address=otlp.monitoring:4318 \
--set-string apisix.nginx.configurationSnippet.httpStart="$configHttp" \
--set-string apisix.nginx.configurationSnippet.httpSrv="$configServer" \
--set ingress-controller.enabled=true \
--namespace ingress-apisix
helm install apisix-dashboard apisix/apisix-dashboard \
--namespace ingress-apisix
dynKubectl "apply" apisix/templates/tls.yaml ingress-apisix