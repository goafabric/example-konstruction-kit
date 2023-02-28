# url
https://istio.io/latest/docs/tasks/security/authentication/authn-policy/

# strict
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
    name: "default"
    namespace: "istio-system"
spec:
    mtls:
        mode: STRICT
EOF

# label
kubectl label namespace default istio-injection=enabled

# cleanup
kubectl get peerauthentication -n istio-system default
kubectl delete peerauthentication -n istio-system default

# busybox
kbusybox
wget http://person-service-application.example-tenant-0:8080