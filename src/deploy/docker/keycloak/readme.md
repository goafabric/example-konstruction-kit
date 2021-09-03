# Standard Keycloak 15, Arm64+X86
docker run --name=keycloak --rm -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p8080:8080 simaofsilva/keycloak:15.0.2

# Keycloak-X 12, Arm64+X86
docker run --name=keycloak --rm -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -p8080:8080 svefors/keycloak-x:12.0.2 start-dev

# Standard Keycloak-X 15 Offical, X86
docker run --name=keycloak --rm -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -p8080:8080 quay.io/keycloak/keycloak-x:15.0.1 start-dev

# Adduser
docker exec keycloak-application \
/opt/jboss/keycloak/bin/add-user-keycloak.sh \
-u admin \
-p admin \
&& docker restart keycloak-application
