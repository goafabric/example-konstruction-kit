#!/bin/bash
kubectl create namespace core; kubectl label namespace core istio.io/dataplane-mode=ambient
kubectl create namespace example; kubectl label namespace example istio.io/dataplane-mode=ambient
kubectl create namespace event; kubectl label namespace event istio.io/dataplane-mode=ambient

kubectl create namespace oidc; kubectl label namespace oidc istio.io/dataplane-mode=ambient
kubectl create namespace monitoring; kubectl label namespace monitoring istio.io/dataplane-mode=ambient

kubectl label pods -l app.kubernetes.io/name=apisix istio.io/dataplane-mode=ambient -n ingress-apisix --overwrite
kubectl create namespace kong; kubectl label namespace kong istio.io/dataplane-mode=ambient --overwrite

#sonarqube and metallb do not seem to be working