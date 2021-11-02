#documentation
https://microk8s.io/docs

#Microk8s Install (replace admin with your user)
sudo snap install microk8s --classic --channel=1.19
sudo usermod -a -G microk8s admin && sudo chown -f -R admin ~/.kube
su - admin

#Microk8s Configure
microk8s enable dns ingress storage

#Kubectl Alias
sudo sh -c 'echo "#!/bin/bash \n microk8s kubectl "\$1" "\$2" "\$3" "\$4" "\$5" "\$6" "\$7" "\$8" "\$9" " > /usr/local/bin/kubectl' && sudo chmod +x /usr/local/bin/kubectl

#Client Kubectl
microk8s config > config (should be put to ~/.kube on client machine)



#Microk8s 1.22 Upgrade
sudo snap install microk8s --classic --channel=1.22/stable
=> This works now, however the nginx-ingress deamonset has to be changed "--ingress-class=public => --ingress-class=nginx"

#Port Forward
sudo iptables -P FORWARD ACCEPT
=> may be needed for som systems