# user (replace with your user)
adduser --ingroup sudo andreas

# Microk8s Install
sudo snap install microk8s --classic --channel=1.28/stable

# Microk8s Config
# mkdir ~/.kube && sudo microk8s config > ~/.kube/config && chmod 600 ~/.kube/config && sudo usermod -a -G microk8s $user && sudo chown -f -R $user ~/.kube

# Docker Registry Proxy if needed
see other file + microk8s stop && microk8s start

# Microk8s Addons
microk8s enable dns ingress storage

sudo microk8s enable metallb storage dns$dns
ip range needs to be set to you server ip from dns, e.g: 152.53.18.28-152.53.18.28

# Kubectl + Helm
sudo sh -c 'echo "#!/bin/bash \n microk8s kubectl "\$1" "\$2" "\$3" "\$4" "\$5" "\$6" "\$7" "\$8" "\$9" " > /usr/local/bin/kubectl' && sudo chmod +x /usr/local/bin/kubectl

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

                                                                                                                                            
# uninstall
sudo snap remove microk8s --purge