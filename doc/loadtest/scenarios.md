# spring native
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service-native:4.0.0
         
70 MB / 13860 req/s

# quarkus native
docker run --name calle-service-quarkus --rm -p 50900:50900 goafabric/callee-service-quarkus:3.35.4

35 MB / 13865 req/s

# spring jvm
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service:4.0.5-SNAPSHOT

260 MB / 15861 req/s

# go
docker run --rm --name callee-service-go -p50900:50900 -e 'DB_HOST=192.168.4.101' goafabric/callee-service-go:1.0.1

20 MB / 15823 req/s

# python
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service-python:1.0.0-SNAPSHOT    
     
66 MB / 1804 req/s

