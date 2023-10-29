#convert example konstruction kit server.pem -> p12
openssl pkcs12 -export -in server.pem -inkey server.key -out kubernetes.p12 -name "goafabric" -passin pass:kubernetes -passout pass:goafabric
                                                     
#convert root.pem -> p12
openssl pkcs12 -export -in root.pem -inkey root.key -out example-root.p12 -passin pass:kubernetes -passout pass:kubernetes

#convert pem -> jks
keytool -import -file client.pem -keystore example-client.jks -alias serverCA
keytool -import -file root.pem -keystore root.jks -alias serverCA

#curl with root/server cert
curl --cacert /usr/share/truststore/example-root.pem https://callee-service-application:8080
curl -u admin:admin --cacert /usr/share/truststore/example-root.pem https://kubernetes/callee/0
                    
#curl with client cert
curl -i --cert ./config/client.pem --key ./config/client.key https://kubernetes:50900
curl -i --cert ./config/root.pem --key ./config/root.key https://kubernetes:50900


