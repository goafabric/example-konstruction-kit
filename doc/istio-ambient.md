# description
- istio is a service mesh that adds observability, mtls and other things to kubernetes
- it comes in to flavors
  - traditional sidecar mode that adds a proxy to every pod, that consumes 50MB of RAM and 0,5 CPU (Osi Layer 7)
  - modern ambient sidecar less mode, that operates at osi layer 4, via a component called Ztunnel

# problems with ambient mode (measures with version 1.28)
  
##  incompatibility with twistlock 
- https://github.com/istio/istio/issues/55937#issuecomment-3003898706
- ⇒ can be fixed with setting "env.ENABLE_ORIG_SRC = false" inside istio helm chart, 

## network policies from bitnami charts like kakfa, s3minio might interfere 
- https://istio.io/latest/docs/ambient/usage/networkpolicy/
- ⇒ can be simply disabled, or charts not used at all

## server might not survive server restart ()
- https://github.com/istio/istio/issues/55913, https://github.com/istio/istio/issues/55968
- ⇒ see drain redeploy fix below, also improvements expected from istio 1.28+ on
                                                                        
# consequences of not using istio at all
- no mtls inside kubernetes cluster, this also means no authentication via client certificate
- no roundrobin / load balancing between backend2backend calls, rest calls will usually "optimize" for pod affinity and stick to one pod only
- no enhanced observability via kiali

# when to choose which option
- if mtls / authentication AND observability are not required AND there is a fix for backend2backend => then istio is not required
- if there is one or more requirement and the describes issues above are solvable ⇒ use ambient mode, its the future-proof leightweight mode
- if there is one ore more requirement and the described issues are NOT solvable ⇒ use traditional side-car mode and accepts the extra resource usage / costs
- ⇒ please note adding istio halfway in a project is always a tangible risk and needs to be verified first in pre production environments

# drain redeploy to fix restart issue
for ns in $(kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{.items[*].metadata.name}'); do kubectl get pods -n $ns -o name | xargs -r -n1 -I{} kubectl label -n $ns {} istio-drain=true --overwrite; done
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 -I{} kubectl drain {} --ignore-daemonsets --delete-emptydir-data --timeout=30s --pod-selector=istio-drain=true
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -n1 kubectl uncordon

#kubectl get ns -l istio.io/dataplane-mode=ambient -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -v '^istio-system$' | xargs -I{} sh -c 'kubectl get pods -n "{}" -o name | xargs -r -n1 -I% kubectl label -n "{}" % istio-drain=true --overwrite'
     


