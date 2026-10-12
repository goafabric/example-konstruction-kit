
# substrate
https://github.com/agent-substrate/substrate#quickstart-development

hack/create-kind-registry.sh => needs to be copied inside ./hack directory && after execution removed !

hack/install-ate-kind.sh --deploy-ate-system --credential-provider='{"name":"k8s.io"}'

go install ./cmd/kubectl-ate
                                    
# demo

hack/install-ate-kind.sh --deploy-demo-counter

kubectl ate get workers
                          
## create and resume actor
kubectl ate create actor my-counter-1 -a ate-demo-counter --template counter

kubectl ate resume actor my-counter-1 -a ate-demo-counter

kubectl ate get actor my-counter-1 -a ate-demo-counter
                          
## suspend actor

kubectl ate suspend actor my-counter-1 -a ate-demo-counter

kubectl ate get actor my-counter-1 -a ate-demo-counter
 
## wake up suspended actor via http

kubectl port-forward -n ate-system svc/atenet-router 8000:80

curl -X POST \
-H "ate-target-actor: ate-demo-counter/my-counter-1" \
http://localhost:8000

kubectl ate suspend actor my-counter-1 -a ate-demo-counter

                        
## delete actor

kubectl ate delete actor my-counter-1 -a ate-demo-counter
              
# ax
https://agentexecutor.io/

go install github.com/google/ax/cmd/ax@latest

make deploy AX_IMAGE_REPO=localhost:5001

