https://agentexecutor.io/

# substrate
hack/create-kind-registry.sh

hack/create-kind-cluster.sh

hack/install-ate-kind.sh --deploy-ate-system
              
# ax
go install github.com/google/ax/cmd/ax@latest

make deploy AX_IMAGE_REPO=localhost:5001

