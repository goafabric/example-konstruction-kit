# test scenario execution
- start one of the containers below
- k6 ./callee.js (loadtest via grafana k6)

# spring native
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service-native:4.0.0
         
70 MB / 300% CPU / 13860 req/s

# quarkus native
docker run --name calle-service-quarkus --rm -p 50900:50900 goafabric/callee-service-quarkus:3.35.4

35 MB / 300% CPU / 13865 req/s

# spring jvm
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service:4.0.5-SNAPSHOT

260 MB / 300% CPU / 15861 req/s

# go
docker run --rm --name callee-service-go -p50900:50900 -e 'DB_HOST=192.168.4.101' goafabric/callee-service-go:1.0.1

20 MB / 172% CPU / 15823 req/s

# python 1 worker
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-python:1.0.0-SNAPSHOT    

66 MB / 100% CPU / 1804 req/s

# python 4 worker
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-python:1.0.1-SNAPSHOT    

290 MB / 400% CPU / 4500 req/s
            
# c# dotnet
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-net:1.0.0-SNAPSHOT    
40 MB / 150% CPU / 18000 req/s