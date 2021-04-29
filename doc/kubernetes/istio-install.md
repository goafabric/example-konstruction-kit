# Istio
- https://istio.io/latest/docs/setup/getting-started/
- Download: https://github.com/istio/istio/releases/tag/1.9.2
  
- istioctl install --set profile=default -y
- kubectl apply -f samples/addons
- infra/05_dashboard/istio/ ./xstack up