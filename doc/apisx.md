API_KEY=edd1c9f034335f136f87ad84b625c8f1

kubectl -n ingress-apisix get cm apisix -o yaml | grep key                                                 

curl http://apisix-admin.ingress-apisix:9180/apisix/admin/routes -H "X-API-KEY: $API_KEY"

curl http://apisix-admin.ingress-apisix:9180/apisix/admin/upstreams/38d90fbb -H "X-API-KEY: $API_KEY"