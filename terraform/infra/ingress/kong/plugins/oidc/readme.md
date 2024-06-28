# plugin used
https://github.com/revomatico/kong-oidc

# example for docker build
https://github.com/Darguelles/kong-oidc-keycloak

# build it
docker build -f ./Dockerfile . -t goafabric/kong-oidc:3.6.0 && docker push goafabric/kong-oidc:3.6.0