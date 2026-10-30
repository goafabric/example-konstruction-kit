
# preparations
https://github.com/agent-substrate/substrate#quickstart-development

./create-kind-registry.sh 
                          
## inside substrate directory
go install ./cmd/kubectl-ate

export ATE_INSTALL_KIND=true && go run ./cmd/ate-setup deploy ate-system --credential-provider='{"name":"k8s.io"}' --ingress-allowed-spiffe-ids=spiffe://cluster.local/ns/ate-system/sa/atenet-client

export ATE_INSTALL_KIND=true && go run ./cmd/ate-setup deploy demo counter


## create and resume actor
kubectl ate create actor my-counter-1 -a ate-demo-counter --template counter

kubectl ate resume actor my-counter-1 -a ate-demo-counter
 
## suspend actor

kubectl ate suspend actor my-counter-1 -a ate-demo-counter
 
## wake up suspended actor via http

kubectl ate proxy actor my-counter-1 -a ate-demo-counter

curl -X POST \
-H "ate-target-actor: ate-demo-counter/my-counter-1" \
http://localhost:8000

kubectl ate suspend actor my-counter-1 -a ate-demo-counter
 
## delete actor

kubectl ate delete actor my-counter-1 -a ate-demo-counter
 
## kill demo pods after kind restart

kubectl delete pods -n ate-demo-counter --all && kubectl ate delete actor my-counter-1 -a ate-demo-counter && kubectl ate create actor my-counter-1 -a ate-demo-counter --template counter

# ax
https://agentexecutor.io/

go install github.com/google/ax/cmd/ax@latest

make deploy AX_IMAGE_REPO=localhost:5001

