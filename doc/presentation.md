#Basics
- JVM => Java Virtual Machine (Oracle Hotspot, IBM OpenJ9)
    - JIT => Just in Time compilation, dev compiler translates Sourcecode to Pseudo/Byte Code (Java, NodeJS)
        - JVM => Translates Pseudo Code to Machine Code during Runtime (JIT)
        - Code can be optimized during Runtime

- GraalVM => Java Virtual Machine Alternative by Oracle that ALSO allows AOT
- AOT => Ahead of Time compilation, dev compiler translates Sourcecode to Machine Code (like c++)
    => Optimization need to be predicted upfront

- Quarkus => Framework that combines Eclipse Microprofile, Vertx, Graalvm to build Cloud Native Applications  
- Spring Boot => Framework to build Microservices  

#Resource Usage in Kubernetes
- Show Spring Boot JVM
- Show Quarkus
- Startup Times
 
#Load Tests Results
- Quarkus and Spring Boot JVM

- Quarkus uses only 1/20 of Memory
- Similar CPU Usage until 100/s
- Quarkus uses 50% more CPU Usage unter high load (400/s)

=> Quarkus is perfect for On Premise Installations (Memory important, High Load not so ...)
=> But less good for Cloud Installations under High Load (CPU more expensive than memory)
=> There is never a silver bullet in architecture

#Live Compile CalleeService
- JVM Compile => 10 sec, nearly no RAM usage
- Native Compile => 2min, 4 GB RAM, 100% CPU

- Source Code and ALL Libraries need to be compatible with Compilation
    - Dynamic Runtime Code (Reflection, ByteCode Modification) is problematic => Hints
    
#Source Code Compare 
- Spring vs Quarkus Project
- Very similar ...
- Spring still has better support for Databases (Spring Data Elastic, Mongo ...)
- Quarkus Documentation is easier to swallow: https://quarkus.io/guides/

#Features
- Web, Health, Prometheus, ExceptionHandler
- Lombok, Mapstruct
- Security
- JPA, Bean Validation

- Swagger
- Flyway
- Cache
- Resilience
- Duration Logger Aspect

- Jaspyt Database Encryption
- Auditing
- Multi Tenancy