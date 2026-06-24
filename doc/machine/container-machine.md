container machine create python:3.12-slim --name dev --cpus 6 --memory 8g

container machine run -n dev

container machine ls

container machine stop dev

container machine rm dev

###

container build -t local/ubuntu -f Dockerfile.ubuntu
                
###
container machine create local/ubuntu --name micro --cpus 6 --memory 8g
sleep 1
container machine run "sudo sh -c 'echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf'"

container machine run -n micro sudo snap install microk8s --classic --channel=1.34/stable
container machine run -n micro sudo microk8s enable hostpath-storage 

container machine run -n micro sudo microk8s config view > ~/.kube.profile/.kube.micro/config        
container machine run -n micro sudo microk8s config view > ~/.kube/config

container machine run -n micro "sudo bash -c 'IP=\$(hostname -I | awk \"{print \\\$1}\") && sudo microk8s enable metallb:\$IP-\$IP'"

                           
###
container machine run -n micro
container machine stop micro
container machine rm micro

# python3 -m http.server 8080

# istio fix

# Access the VM                                                                                                                                                        ┃                       ┃    223Z
container machine run -n micro "sudo sh -c 'printf \"[Unit]\nDescription=Make root and /run mounts shared\nDefaultDependencies=no\nAfter=local-fs.target\nBefore=kubele┃  Copied to clipboard  ┃                                            
nType=oneshot\nExecStart=/bin/mount --make-rshared /\nExecStart=/bin/mount --make-rshared /run\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target\n\" > /etc┃                       ┃    Context                                 
rshared.service'"                                                                                                                                                                                   29,755 tokens                           
                                                                                                                                                                                                 0% used                                 
container machine run -n micro "sudo systemctl daemon-reload && sudo systemctl enable --now mount-rshared.service" 