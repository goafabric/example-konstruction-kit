# test scenario execution
- start one of the containers below
- k6 run ./callee.js (loadtest via grafana k6)

# spring native
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service-native:4.1.0
         
70 MB / 300% CPU / 16391 req/s

# quarkus native
docker run --name calle-service-quarkus --rm -p 50900:50900 goafabric/callee-service-quarkus:3.35.4

35 MB / 300% CPU / 17054 req/s

# spring jvm
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service:4.1.0

220 MB / 260% CPU / 18737 req/s

# go
docker run --rm --name callee-service-go -p50900:50900 -e 'DB_HOST=192.168.4.101' goafabric/callee-service-go:1.0.1

20 MB / 172% CPU / 18684 req/s

# python 1 worker
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-python:1.0.0-SNAPSHOT    

66 MB / 100% CPU / 1804 req/s

# python 4 worker
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-python:1.0.1-SNAPSHOT    

290 MB / 400% CPU / 4500 req/s
            
# c# dotnet
docker run --pull always --name callee-service --rm -p 50900:50900 goafabric/callee-service-net:1.0.0-SNAPSHOT    
65 MB / 150% CPU / 20000 req/s (on the 2nd run!)
               

# rust
docker run --name callee-service --rm -p 50900:50900 goafabric/callee-service-rust:1.0.0
       
7 MB / 200% CPU / 18500 req/s
                        
# table
| Framework          |  Req/s | CPU Usage | Memory Usage | Req/s per CPU % | Req/s per MB |
| ------------------ | -----: | --------: | -----------: | --------------: | -----------: |
| Rust                 | 18,500 |      200% |        7 MB |        **92** |    **2642** |
| Go                 |18,684 |      172% |        20 MB |        **108** |    **934** |
| C# (.NET)          | 20,000 |      150% |        40 MB |       **120** |        450.0 |
| Quarkus Native     |17,054 |      300% |        35 MB |            56.84 |        487,0 |
| Spring Native      | 16,391 |      300% |        70 MB |            54.63 |        234.0 |
| Spring JVM         | 18,737 |      260% |       220 MB |            72.0 |         85.0 |
| Python (1 worker)  |  1,804 |      100% |        66 MB |            18.0 |         27.3 |
| Python (4 workers) |  4,500 |      400% |       290 MB |            11.3 |         15.5 |
