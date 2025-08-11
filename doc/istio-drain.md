# div
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl drain --ignore-daemonsets --delete-emptydir-data --timeout 30s

kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl uncordon

# rerollout

kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
| xargs -I{} sh -c 'kubectl rollout restart deploy -n {}; kubectl rollout restart statefulset -n {}'