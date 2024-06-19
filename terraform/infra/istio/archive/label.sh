#!/bin/bash
kubectl create namespace core; kubectl label namespace core istio.io/dataplane-mode=ambient
kubectl create namespace example; kubectl label namespace example istio.io/dataplane-mode=ambient
kubectl create namespace event; kubectl label namespace event istio.io/dataplane-mode=ambient
kubectl create namespace invoice; kubectl label namespace invoice istio.io/dataplane-mode=ambient

kubectl create namespace dashboard; kubectl label namespace dashboard istio.io/dataplane-mode=ambient
#kubectl create namespace grafana; kubectl label namespace grafana istio.io/dataplane-mode=ambient

kubectl label pods -l app.kubernetes.io/name=apisix istio.io/dataplane-mode=ambient -n ingress-apisix --overwrite
kubectl create namespace kong; kubectl label namespace kong istio.io/dataplane-mode=ambient --overwrite

#kubectl create namespace oidc; kubectl label namespace oidc istio.io/dataplane-mode=ambient #works but needs to many restart
#sonarqube and metallb do not seem to be working