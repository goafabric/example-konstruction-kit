kubectl create namespace example
kubectl label namespace example istio.io/dataplane-mode=ambient

kubectl create namespace example-tenant-0
kubectl label namespace example-tenant-0 istio.io/dataplane-mode=ambient

kubectl create namespace example-tenant-5a2f
kubectl label namespace example-tenant-5a2f istio.io/dataplane-mode=ambient

kubectl delete namespace example-tenant-0
kubectl delete namespace example-tenant-5a2f
kubectl delete namespace example