https://www.msbiro.net/posts/apple-container-local-kubernetes-sighup-distribution/

container k8s create --cpus 8 --memory 8g

cp ~/.kube/config ~/.kube.profile/.kube.kind2/ && kprofile kind2

export TF_VAR_hostname=kind2.local

container k8s list

container stop k8s-dev
                               
container k8s delete
