##Step 1

#documentation
https://microk8s.io/docs

#Microk8s Install (replace ubuntu with your user)
sudo snap install microk8s --classic --channel=1.19
sudo usermod -a -G microk8s ubuntu && sudo chown -f -R ubuntu ~/.kube

sudo iptables -P FORWARD ACCEPT



