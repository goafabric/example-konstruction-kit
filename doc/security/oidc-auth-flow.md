# 1) Frontend Authentication Flow

## Frontend

### GOAL: retrieve ONE-TIME-CODE based on client-id and USERNAME/PASSWORD entered 

- client-id provided via the #frontend
- http://localhost:8081/oauth2/authorize?client_id=oauth2-proxy&response_type=code&scope=openid
- #openid-provider login screen
- #user types in username/password
- #openid-provider returns one-time-code based on client-id and username/password

## Backend
### GOAL: retrieve jwt based on client-id & ONE-TIME-CODE

- #backend sends client-id & ONE-TIME-CODE to #token-endpoint
- #token-endpoint returns real jwt 

- #backend calls #userinfo to retrieve additional information

- => authentication successfull

# 2) Backend2Backend Bearer Token
### GOAL: retrieve jwt based on client-id & USERNAME/PASSWORD

- #backend sends client-id & USERNAME/PASSWORD to #token-endpoint
- #token-endpdoint returns real jwt

- => jwt can be used to authenticate to other backend

