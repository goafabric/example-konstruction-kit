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
                                       
# table
| Framework          |  Req/s | CPU Usage | Memory Usage | Req/s per CPU % | Req/s per MB |
| ------------------ | -----: | --------: | -----------: | --------------: | -----------: |
| Go                 | 15,823 |      172% |        20 MB |        **92.0** |    **791.2** |
| C# (.NET)          | 18,000 |      150% |        40 MB |       **120.0** |        450.0 |
| Quarkus Native     | 13,865 |      300% |        35 MB |            46.2 |        396.1 |
| Spring Native      | 13,860 |      300% |        70 MB |            46.2 |        198.0 |
| Spring JVM         | 15,861 |      300% |       260 MB |            52.9 |         61.0 |
| Python (1 worker)  |  1,804 |      100% |        66 MB |            18.0 |         27.3 |
| Python (4 workers) |  4,500 |      400% |       290 MB |            11.3 |         15.5 |
