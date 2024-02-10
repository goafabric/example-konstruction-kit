_#Based on Ubuntu 20 Focal

#user (replace with your user)
user=andreas

#system 
sudo apt --assume-yes update  
sudo apt --assume-yes install mc && sudo apt --assume-yes install net-tools

#ssh 
adduser --ingroup sudo $user

#Docker 
sudo apt --assume-yes install docker.io && sudo apt --assume-yes install docker-compose && sudo systemctl enable docker &&  sudo service docker start
sudo usermod -aG sudo $user && sudo usermod -aG docker $user
sudo docker run --rm hello-world

#Portainer
sudo docker volume create portainer_data && sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.16.1

#Geekbench
wget https://cdn.geekbench.com/Geekbench-5.4.1-Linux.tar.gz, wget https://cdn.geekbench.com/Geekbench-5.4.0-LinuxARMPreview.tar.gz

#Helm 3
https://github.com/helm/helm/releases_