# Istio
- Download Istioctl CLI: https://istio.io/latest/docs/setup/getting-started/
- infra/06_addon/istio ./stack init
=> you may have to do this twice at least for the kiali spring boot dashboards

- istioctl dashboard kiali
       
# Linkerd
- Download Linkerd CLI: https://linkerd.io/2.10/getting-started/
- infra/06_addon/linkerd ./stack init

- linkerd (viz) dashboard

# Kubernetes Dashboard
- kubectl proxy
- http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

