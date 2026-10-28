FROM kindest/node:v1.37.0
COPY zscaler.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

#unset DOCKER_HOST && docker build -t kindest/node-cert:v1.37.0 -f ./cert/Dockerfile ~/Documents/Zscaler/