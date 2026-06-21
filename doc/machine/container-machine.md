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

container machine run -n micro sudo microk8s enable metallb:$(hostname -I | awk '{print $1}')-$(hostname -I | awk '{print $1}')

container machine run -n micro sudo microk8s config view > ~/.kube.profile/.kube.micro/config        
container machine run -n micro sudo microk8s config view > ~/.kube/config
                           
###
container machine run -n micro
container machine rm micro