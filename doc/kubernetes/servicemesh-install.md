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

--


#Linkerd
microk8s enable linkerd
linkerd install | kubectl apply -f -
linkerd uninstall | kubectl delete -f -

#Linkerd CLI download
https://github.com/linkerd/linkerd2/releases/

#Linkerd Dashboard (dd remove line, O insert -enforced-host=)
microk8s.kubectl edit deployment/linkerd-web --namespace=linkerd
- -enforced-host=^(localhost|127\.0\.0\.1|linkerd-web\.linkerd\.svc\.cluster\.local|linkerd-web\.linkerd\.svc|\[::1\])(:\d+)?$
