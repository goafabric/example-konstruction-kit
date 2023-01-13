# 1) Frontend Authentication Flow

## Frontend

### GOAL: retrieve ONE-TIME-CODE via FRONTEND based on client-id and USERNAME/PASSWORD entered 

- client-id provided via the #frontend to #authorization-endpoint
- http://localhost:8081/oauth2/authorize?client_id=oauth2-proxy&response_type=code&scope=openid
- #openid-provider login screen
- #user types in username/password
- #openid-provider returns one-time-code based on client-id and username/password

## Backend
### GOAL: retrieve jwt via OIDC PROVIDER based on client-id & ONE-TIME-CODE

- backend sends client-id & ONE-TIME-CODE to #token-endpoint
- #token-endpoint returns real jwt 

- backend calls #userinfo-endpoint to retrieve additional information

- => authentication successfull

# 2) Backend2Backend Bearer Token
### GOAL: retrieve jwt via OIDC PROVIDER based on client-id & USERNAME/PASSWORD

- backend sends client-id & USERNAME/PASSWORD to #token-endpoint
- curl http://localhost:30200/oidc/token?client_id=oauth2-proxy&scope=openid&username=user1&password=user1?grant_type=password
- #token-endpdoint returns real jwt

- => jwt can be used to authenticate to other backend

# 3) Urls

- OAUTH2_PROXY_REDIRECT_URL: "http://localhost:8080/oauth2/callback"

- OAUTH2_PROXY_OIDC_ISSUER_URL: "http://localhost:30200/oidc/realms/tenant-0"
- OAUTH2_PROXY_LOGIN_URL: "http://localhost:30200/oidc/realms/tenant-0/protocol/openid-connect/auth"

- OAUTH2_PROXY_REDEEM_URL: "http://keycloak:8080/oidc/realms/tenant-0/protocol/openid-connect/token"
- OAUTH2_PROXY_OIDC_JWKS_URL: "http://keycloak:8080/oidc/realms/tenant-0/protocol/openid-connect/certs"