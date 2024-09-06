# user (replace with your user)
adduser --ingroup sudo andreas
                  
# create with multipass
multipass launch --name microk8s --memory 8G --cpus 6 --disk 10G

# Microk8s Install
sudo snap install microk8s --classic --channel=1.30/stable


# Microk8s Addons
sudo microk8s enable hostpath-storage
sudo microk8s enable metallb $(hostname -I | awk '{print $1}')-$(hostname -I | awk '{print $1}')

sudo microk8s enable metallb 152.53.18.28-152.53.18.28
         
# Microk8s config

microk8s config view

# Microk8s Config
# mkdir ~/.kube && sudo microk8s config > ~/.kube/config && chmod 600 ~/.kube/config && sudo usermod -a -G microk8s $user && sudo chown -f -R $user ~/.kube

# uninstall
sudo snap remove microk8s --purge