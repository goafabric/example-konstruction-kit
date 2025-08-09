kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl drain --ignore-daemonsets --delete-emptydir-data --grace-period=30

kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl uncordon