# plugin used
https://github.com/revomatico/kong-oidc

# example for docker build
https://github.com/Darguelles/kong-oidc-keycloak

# build it
docker build -f ./Dockerfile --push . -t goafabric/kong-oidc:3.6.0

docker buildx create --name mybuilder --use && docker buildx build --platform linux/amd64,linux/arm64 -t goafabric/kong-oidc:3.6.0 -f ./Dockerfile --push . ; docker buildx stop mybuilder && docker buildx rm mybuilder
