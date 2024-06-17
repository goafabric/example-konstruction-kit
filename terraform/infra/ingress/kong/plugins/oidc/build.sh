#!/bin/bash
docker build -f ./Dockerfile . -t goafabric/kong-oidc:3.6.0 && docker push goafabric/kong-oidc:3.6.0