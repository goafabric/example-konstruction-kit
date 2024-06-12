kubectl create configmap kong-oidc-config --from-file=oidc/ --dry-run=client -o yaml | sed 's/name: kong-oidc-config/name: kong-plugin-oidc/' > kong-plugin-oidc.yaml
kubectl apply -f ./kong-plugin-oidc.yaml -n kong
kubectl delete -f ./kong-plugin-oidc.yaml -n kong
