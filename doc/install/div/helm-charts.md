#helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update   

helm search repo grafana --versions
helm show values grafana/grafana

#grafana
helm repo add grafana https://grafana.github.io/helm-charts

helm install grafana grafana/grafana  --version v6.6.3 --namespace istio-system
helm uninstall grafana --namespace istio-system

#grafana dashboard
kubectl port-forward service/grafana 3000:80 --namespace istio-system
kubectl get secret --namespace istio-system grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

#prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus --version v13.6.0 --set pushgateway.enabled=false --set alertmanager.enabled=false --set nodeExporter.enabled=false --set kubeStateMetrics.enabled=false \
--set server.fullnameOverride=prometheus --set server.service.servicePort=9090 --namespace istio-system

helm uninstall prometheus --namespace istio-system

#kiali
helm repo add kiali https://kiali.org/helm-charts
helm repo update

helm install kiali kiali/kiali-server --set auth.strategy="anonymous" --version v1.34.0 --namespace istio-system
helm uninstall kiali --namespace istio-system
                
#jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install jaeger jaegertracing/jaeger --version v0.39.8 --namespace istio-system
helm uninstall jaeger --namespace istio-system