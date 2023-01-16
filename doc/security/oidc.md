# login
clear
export realm=tenant-0
export credentials=user1
export baseurl=http://localhost:30200
#export baseurl=https://kubernetes

export access_token=$(\
curl -v -s -X POST $baseurl/oidc/realms/$realm/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=$credentials" \
-d "password=$credentials" \
-d "grant_type=password" \
-d "client_id=callee-service" \
-d "scope=openid" \
| jq --raw-output '.access_token' \
)
echo access token is: $access_token

# userinfo
curl -v -H "Authorization: Bearer $access_token" "$baseurl/oidc/realms/$realm/protocol/openid-connect/userinfo"

# localhost service request
curl -v "http://localhost:50900/callees/sayMyName?name=Heisenberg"
curl -v -H "Authorization: Bearer $access_token" -H "X-TenantId: 0" "http://localhost:50900/callees/sayMyName?name=Heisenberg"

# kubernetes service request
curl -v "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"
curl -v -H "Authorization: Bearer $access_token" "https://kubernetes/callee/0/callees/sayMyName?name=Heisenberg"

# doc
https://www.ibm.com/docs/en/was-liberty/base?topic=liberty-invoking-authorization-endpoint-openid-connect
https://developers.onelogin.com/openid-connect