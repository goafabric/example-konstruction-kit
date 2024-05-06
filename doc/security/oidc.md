# login
clear
export realm=tenant-0
export baseurl=https://kind
#export baseurl=http://localhost:30200

export access_token=$(\
curl -k -v -s -X POST $baseurl/oidc/realms/$realm/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=user1" \
-d "password=User1user1" \
-d "grant_type=password" \
-d "client_id=oauth2-proxy" \
-d "scope=openid" \
| jq --raw-output '.access_token' \
)
echo access token is: 
echo $access_token                                                                      

https://your-keycloak-server/auth/admin/realms/your-realm/users


# jwt.io 
https://jwt.io/

# userinfo
curl -k -v -H "Authorization: Bearer $access_token" "$baseurl/oidc/realms/$realm/protocol/openid-connect/userinfo"

# localhost service request
curl -k -v "http://localhost:50900/callees/sayMyName?name=Heisenberg"
curl -k -v -H "Authorization: Bearer $access_token" -H "X-TenantId: 0" "http://localhost:50900/callees/sayMyName?name=Heisenberg"

# kubernetes service request
curl -k -v "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"
curl -k -v -H "Authorization: Bearer $access_token" "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"

# doc
https://www.ibm.com/docs/en/was-liberty/base?topic=liberty-invoking-authorization-endpoint-openid-connect
https://developers.onelogin.com/openid-connect

# spring auth server client grant
export access_token=$(\
curl -v -s -X POST http://127.0.0.1:30200/oidc/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Authorization: BASIC b2F1dGgyLXByb3h5Om5vbmU=" \
-d "grant_type=client_credentials" \
-d "scope=openid" \
| jq --raw-output '.access_token'
)
echo access token is: $access_token

# userinfo not working
curl -v -H "Authorization: Bearer $access_token" "http://127.0.0.1:30200/oidc/userinfo"

# keycloak client grant (secrent inside BASIC auth needs to be updated!)
export access_token=$(\
curl -v -s -X POST http://localhost:30200/oidc/realms/tenant-0/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Authorization: BASIC b2F1dGgyLXByb3h5OlM3Q2FxYjVSdzk5OVZsUFBEdVY5R0dzM1hZejgzNFJL " \
-d "grant_type=client_credentials" \
-d "scope=openid" \
| jq --raw-output '.access_token'
)
echo access token is: $access_token

# userinfo 
curl -v -H "Authorization: Bearer $access_token" "http://127.0.0.1:30200/oidc/realms/tenant-0/protocol/openid-connect/userinfo"

# issuer
curl http://localhost:30200/.well-known/openid-configuration
curl http://kubernetes:30200/.well-known/openid-configuration

# keycloak
curl http://localhost:30200/oidc/realms/master/.well-known/openid-configuration
curl http://keycloak:8080/oidc/realms/master/.well-known/openid-configuration