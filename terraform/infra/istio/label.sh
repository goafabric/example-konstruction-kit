#!/bin/bash
kubectl create namespace core; kubectl label namespace core "istio.io/dataplane-mode"="ambient"
kubectl create namespace example; kubectl label namespace example "istio.io/dataplane-mode"="ambient"
kubectl create namespace message-broker; kubectl label namespace message-broker "istio.io/dataplane-mode"="ambient"

kubectl label namespace ingress-apisix "istio.io/dataplane-mode"="ambient"