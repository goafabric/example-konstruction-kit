# Istio
##doc
https://istio.io/latest/docs/setup/getting-started/

##install
istioctl install  --set profile=default -y

##dashboard
kubectl apply -f samples/addons
istioctl dashboard kiali
infra/05_dashboard/istio/ ./xstack up

##uninstall
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system &&  kubectl delete namespace istio-operator
kubectl delete -f samples/addons

##arm64
https://github.com/querycap/istio