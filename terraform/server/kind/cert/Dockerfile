FROM kindest/node:v1.34.0
COPY  ~/Documents/Zscaler/zscaler.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

#docker build -t kindest/node-cert:v1.34.0 -f ./cert/Dockerfile ./cert