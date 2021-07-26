#helm
helm list -A
helm uninstall loki --namespace=loki

#loki
##repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

##install
kubectl create namespace loki

helm upgrade --install loki --namespace=loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

helm upgrade --install loki --namespace=loki grafana/loki
helm upgrade --install promtail --namespace=loki grafana/promtail --set "loki.serviceName=loki"

##uninstall
helm uninstall loki --namespace=loki
helm uninstall promtail --namespace=loki

##dashboard
kubectl port-forward service/loki-grafana 3000:80 --namespace=loki
kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
              
#query
{container="person-service-application",namespace="example-tenant-0"}

#doc
https://grafana.com/docs/loki/latest/installation/helm/
