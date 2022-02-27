#genereate p12
keytool -genkeypair -alias goafabric -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore goafabric.p12 -validity 3650

#convert example konstruction kit server.pem -> p12
openssl pkcs12 -export -in server.pem -inkey server.key -out kubernetes.p12 -name "goafabric" -passin pass:kubernetes -passout pass:goafabric
                                                     
#convert root.pem -> p12
openssl pkcs12 -export -in root.pem -inkey root.key -out root.p12 -passin pass:kubernetes -passout pass:goafabric

#curl
curl --cacert /usr/share/truststore/root.pem https://callee-service-application:8080

curl -u admin:admin --cacert /usr/share/truststore/root.pem https://kubernetes/callee/0

#links
https://www.baeldung.com/spring-boot-https-self-signed-certificate
https://www.baeldung.com/x-509-authentication-in-spring-security
https://baeldung-cn.com/spring-tls-setup
