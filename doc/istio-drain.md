# div
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl drain --ignore-daemonsets --delete-emptydir-data --timeout 30s

kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl uncordon