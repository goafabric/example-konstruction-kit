# token with AUTHORIZATION_CODE (username / password) (not working any more)

export realm=tenant-0
export baseurl=https://kind
#export baseurl=http://localhost:30200

export access_token=$(\
curl -k -v -s -X POST https://v2202402203466256255.megasrv.de/oidc/realms/tenant-0/protocol/openid-connect/token \
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

# token with CLIENT Credentials (needs client with client authentication + authorization enabled!, password als set in route.yaml!)
export realm=tenant-0
export baseurl=https://kind
#export baseurl=http://localhost:30200

export access_token=$(
curl -k -s -X POST \
https://v2202402203466256255.megasrv.de/oidc/realms/tenant-0/protocol/openid-connect/token \
-u backend:jbUh7EpYUNGi84ngnlYOf6qVJ8t03Als \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=client_credentials" \
| jq -r '.access_token'
)
echo $access_token


# request
curl -k -v -H "Authorization: Bearer $access_token" "https://v2202402203466256255.megasrv.de/core/patients/findByGivenName?givenName=S"
    
# request with callee-service
curl -k -v -H "Authorization: Bearer $access_token" "https://v2202402203466256255.megasrv.de/callee/backend/callees/sayMyName?name=Heisenberg" 


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
