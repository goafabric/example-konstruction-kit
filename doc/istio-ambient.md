# drain redeploy to fix restart issue
for ns in $(kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{.items[*].metadata.name}'); do kubectl get pods -n $ns -o name | xargs -r -n1 -I{} kubectl label -n $ns {} istio-drain=true --overwrite; done
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 -I{} kubectl drain {} --ignore-daemonsets --delete-emptydir-data --timeout=30s --pod-selector=istio-drain=true
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl uncordon

#kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -v '^istio-system$' | xargs -I{} sh -c 'kubectl get pods -n "{}" -o name | xargs -r -n1 -I% kubectl label -n "{}" % istio-drain=true --overwrite'
     
# bitnami helm network policies

should be deactivated in helm charts, e.g. with S3 and Kafka Policies, connections wont work
see here why: https://istio.io/latest/docs/ambient/usage/networkpolicy/

# issues
https://github.com/istio/istio/issues/55913
https://github.com/istio/istio/issues/55968

# rerollout (not working)
kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
| xargs -I{} sh -c 'kubectl rollout restart deploy -n {}; kubectl rollout restart statefulset -n {}'


