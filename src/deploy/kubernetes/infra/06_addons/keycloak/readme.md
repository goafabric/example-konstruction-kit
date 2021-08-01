https://hub.docker.com/r/jboss/keycloak


docker run -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p8080:8080 simaofsilva/keycloak:15.0.0

docker run -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -p8080:8080 svefors/keycloak-x:12.0.2 start-dev