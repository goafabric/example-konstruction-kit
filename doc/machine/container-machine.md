container machine create python:3.12-slim --name dev --cpus 6 --memory 8g

container machine run -n dev

container machine ls

container machine stop dev

container machine rm dev

# python3 -m http.server 8080
