# login
clear
export realm=tenant-0
export credentials=user1

export access_token=$(\
curl -s -X POST http://localhost:30200/oidc/auth/realms/$realm/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=$credentials" \
-d "password=$credentials" \
-d "grant_type=password" \
-d "client_id=callee-service" \
| jq --raw-output '.access_token' \
)
echo access token is: $access_token

# userinfo
curl -v -H "Authorization: Bearer $access_token" "http://localhost:30200/oidc/auth/realms/$realm/protocol/openid-connect/userinfo"

# localhost service request
curl -v "http://localhost:50900/callees/sayMyName?name=Heisenberg"
curl -v -H "Authorization: Bearer $access_token" -H "X-TenantId: 0" "http://localhost:50900/callees/sayMyName?name=Heisenberg"
