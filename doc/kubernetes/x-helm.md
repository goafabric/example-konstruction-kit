#Download
https://github.com/deploy.helm/deploy.helm/releases

#Repo Add
deploy.helm repo add stable https://charts.deploy.helm.sh/stable && deploy.helm repo update

#Create
deploy.helm create mychart
                                           
#Search and install
deploy.helm search repo stable
deploy.helm install stable/postgresql --generate-name --set image.repository=postgres --set image.tag=11.5

deploy.helm ls
deploy.helm uninstall postgresql-1609063021
                                
#Doc
https://deploy.helm.sh/docs/intro/quickstart/
https://docs.bitnami.com/tutorials/create-your-first-deploy.helm-chart/


