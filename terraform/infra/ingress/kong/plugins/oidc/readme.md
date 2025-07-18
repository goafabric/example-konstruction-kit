# plugin used
https://github.com/revomatico/kong-oidc

# example for docker build
https://github.com/Darguelles/kong-oidc-keycloak

# build it
docker buildx create --name mybuilder --use && docker buildx build --platform linux/amd64,linux/arm64 -t goafabric/kong-oidc:3.9.1 -f ./Dockerfile --push . ; docker buildx stop mybuilder && docker buildx rm mybuilder
