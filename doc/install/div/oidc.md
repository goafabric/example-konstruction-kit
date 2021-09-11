#token
clear
export realm=goafabric
export access_token=$(\
curl -s -X POST https://kubernetes/oidc/auth/realms/$realm/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=user" \
-d "password=user" \
-d "grant_type=password" \
-d "client_id=example-app" \
| jq --raw-output '.access_token' \
)
echo access token is: $access_token

#userinfo
curl -v -H "Authorization: Bearer $access_token" "https://kubernetes/oidc/auth/realms/$realm/protocol/openid-connect/userinfo"

#kubernetes service request
curl -v "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"
curl -v -H "Authorization: Bearer $access_token" "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"
 
#localhost service request
curl -v "http://localhost:50900/callees/sayMyName?name=Heisenberg"
curl -v -H "Authorization: Bearer $access_token" "http://localhost:50900/callees/sayMyName?name=Heisenberg"
