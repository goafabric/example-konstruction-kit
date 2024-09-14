# create with multipass
multipass launch --name microk8s --memory 8G --cpus 6 --disk 10G

# Microk8s Install
sudo snap install microk8s --classic --channel=1.30/stable

# Microk8s Addons
sudo microk8s enable hostpath-storage metrics-server
sudo microk8s enable metallb $(hostname -I | awk '{print $1}')-$(hostname -I | awk '{print $1}')

# Microk8s config
sudo microk8s config view

# uninstall
sudo snap remove microk8s --purge