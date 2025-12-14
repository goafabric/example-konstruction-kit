# div
- Apisix Ingress Initcontainer
- Remove Kong Ingresses
                                                                                               
# info
- 10 best practices: https://www.youtube.com/watch?app=desktop&v=oBf5lrmquYI&pp=ygUSI211dGlyYW9rdWJlcm5ldGVz

# traces
https://github.com/issues/mentioned?issue=spring-projects%7Cspring-boot%7C34801

@Bean
ObservationPredicate disableActuatorSpan() {
    return (name, context) -> !name.equals("http.server.requests") || !(context instanceof ServerRequestObservationContext serverContext) || serverContext.getCarrier() != null && !serverContext.getCarrier().getRequestURI().startsWith("/actuator");    
}