FROM kindest/node:v1.35.0
COPY zscaler.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

#docker build -t kindest/node-cert:v1.35.0 -f ./cert/Dockerfile ~/Documents/Zscaler/