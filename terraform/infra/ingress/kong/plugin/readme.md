kubectl create configmap kong-oidc-config --from-file=oidc/ --dry-run=client -o yaml | sed 's/name: kong-oidc-config/name: kong-plugin-oidc/' > kong-plugin-oidc.yaml
kubectl delete -f ./kong-plugin-oidc.yaml -n kong
kubectl apply -f ./kong-plugin-oidc.yaml -n kong

kubectl create configmap kong-plugin-myheader --from-file=myheader -n kong


docker build -f ./Dockerfile . -t goafabric/kong-oidc:3.6.0 && docker push goafabric/kong-oidc:3.6.0 
