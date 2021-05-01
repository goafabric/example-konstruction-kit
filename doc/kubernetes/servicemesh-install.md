# Istio
- Download Istioctl CLI: https://istio.io/latest/docs/setup/getting-started/
- infra/06_addon/istio ./xstack init

- istioctl dashboard kiali
       
# Linkerd
- Download Linkerd CLI: https://linkerd.io/2.10/getting-started/
- infra/06_addon/linkerd ./xstack init

- linkerd viz dashboard

#Linkerd Dashboard (dd remove line, O insert -enforced-host=)
microk8s.kubectl edit deployment/linkerd-web --namespace=linkerd
- -enforced-host=^(localhost|127\.0\.0\.1|linkerd-web\.linkerd\.svc\.cluster\.local|linkerd-web\.linkerd\.svc|\[::1\])(:\d+)?$
