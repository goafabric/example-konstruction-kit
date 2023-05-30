# links
https://learnk8s.io/kubernetes-long-lived-connections

## timeout
https://www.baeldung.com/spring-webflux-timeout
          
## cloud loadbalancer
https://spring.io/blog/2020/03/25/spring-tips-spring-cloud-loadbalancer
https://docs.spring.io/spring-cloud-kubernetes/docs/current/reference/html/#loadbalancer-for-kubernetes
                
# dependency

implementation("org.springframework.cloud:spring-cloud-starter-kubernetes-client-loadbalancer:3.0.3")
                                                 
# props
spring.cloud.kubernetes.loadbalancer.mode: "POD"