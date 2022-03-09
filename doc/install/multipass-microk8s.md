##Step 1

#documentation
https://microk8s.io/docs

#Microk8s Install (replace ubuntu with your user)
sudo snap install microk8s --classic --channel=1.23/stable
sudo usermod -a -G microk8s ubuntu && sudo chown -f -R ubuntu ~/.kube
su - ubuntu

microk8s enable dns ingress storage

sudo iptables -P FORWARD ACCEPT

kubectl edit daemonset nginx-ingress-microk8s-controller -n ingress



