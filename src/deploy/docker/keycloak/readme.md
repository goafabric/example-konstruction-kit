# Adduser
docker exec keycloak-application \
/opt/jboss/keycloak/bin/add-user-keycloak.sh \
-u admin \
-p admin \
&& docker restart keycloak-application