# Istio
- Download Istioctl CLI: https://istio.io/latest/docs/setup/getting-started/
- infra/06_addon/istio ./stack init
=> you may have to do this twice at least for the kiali spring boot dashboards or prometheus

- istioctl dashboard kiali
       
# Linkerd
- Download Linkerd CLI: https://linkerd.io/2.10/getting-started/
- infra/06_addon/linkerd ./stack init
- linkerd viz dashboard

# Linkerd Manual
- linkerd install | kubectl apply -f -
- linkerd uninstall | kubectl delete -f -

