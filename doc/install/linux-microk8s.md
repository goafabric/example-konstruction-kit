#documentation
https://microk8s.io/docs
                          
#user (replace with your user)
user=admin

#Microk8s Install (
sudo snap install microk8s --classic --channel=1.23/stable
sudo usermod -a -G microk8s $user && sudo chown -f -R $user ~/.kube  
su - $user

#Kubectl Client
microk8s config > ~/.kube/config && chmod 600 ~/.kube/config

#Microk8s Configure
microk8s enable ingress storage
microk8s enable dns

#Kubectl Alias
sudo sh -c 'echo "#!/bin/bash \n microk8s kubectl "\$1" "\$2" "\$3" "\$4" "\$5" "\$6" "\$7" "\$8" "\$9" " > /usr/local/bin/kubectl' && sudo chmod +x /usr/local/bin/kubectl