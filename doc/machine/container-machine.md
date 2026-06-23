container machine create alpine:latest --name dev --cpus 6 --memory 8g

container machine run -n dev

container machine ls

container machine stop dev

container machine rm dev

###

container build -t local/ubuntu -f Dockerfile.ubuntu
                
###
container machine create local/ubuntu --name micro --cpus 6 --memory 8g
sleep 1
container machine run -n micro sudo snap install microk8s --classic --channel=1.34/stable
container machine run -n micro sudo microk8s enable hostpath-storage 

container machine run -n micro sudo microk8s config view > ~/.kube.profile/.kube.micro/config        
container machine run -n micro sudo microk8s config view > ~/.kube/config

#container machine run -n micro "sudo bash -c 'IP=\$(hostname -I | awk \"{print \\\$1}\") && sudo microk8s enable metallb:\$IP-\$IP'"

                           
###
container machine run -n micro
container machine stop micro
container machine rm micro

# python3 -m http.server 8080

###

i am having a special task and please ignore the local workspace folder
if created a so called container machine with microk8s with apples new container machine framework
https://github.com/apple/container/blob/main/docs/container-machine.md

you can list all container machines with "container machine ls"
and you can execute commands like this
"container machine run -n micro <command>"

to enabled metallb i did this
container machine run -n micro sudo microk8s enable metallb:$(hostname -I | awk '{print $1}')-$(hostname -I | awk '{print $1}')
unfortunately i cannot connect via https via its ip adress from the outside, it gives me connection refused
please note that the ip adress might change with every restart of container machine

please diagnose by executing commands inside the machine
and outside via curl until you find a solution


https://kind.local:32443/welcome/


# 1. Fix MetalLB IP pool to current machine IP
IP=$(container machine run -n micro hostname -I | awk '{print $1}')                                                                                                                                 LSP                                     
container machine run -n micro "sudo microk8s kubectl patch ipaddresspool default-addresspool -n metallb-system --type='json' -p='[{\"op\": \"replace\", \"path\": \"/spec/addresses/0\", \         LSPs are disabled                       
"value\": \"${IP}-${IP}\"}]'"                                                                                                                                                                                                               
                                                                                                                                                                                                 Todo                                    
# 2. Patch apisix-gateway to LoadBalancer (only needed once, persists across restarts)                                                                                                              [•] Diagnose MetalLB/microk8s           
container machine run -n micro "sudo microk8s kubectl patch svc apisix-gateway -n ingress-apisix -p '{\"spec\":{\"type\":\"LoadBalancer\"}}'"                                                           connectivity issue in container     
                                                                                                                                                                                                     machine                             
Note: step 2 only needs to run once — the service type is stored in etcd and survives restarts. Only step 1 (MetalLB IP pool) needs to run after every restart since the IP changes.  


