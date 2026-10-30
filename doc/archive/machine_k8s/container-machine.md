container machine create goafabric/microk8s:1.34 --name dev --cpus 6 --memory 8g

container machine create alpine:latest --name dev --cpus 6 --memory 8g

container machine run -n dev

container machine ls

container machine stop dev

container machine rm dev

# python3 -m http.server 8080
