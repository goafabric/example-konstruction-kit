# div
- autoscale

# security
- secrets via vault
- volume encryption
- rbac                                                                                                               k
                                                                                               
# info
- 10 best practices: https://www.youtube.com/watch?app=desktop&v=oBf5lrmquYI&pp=ygUSI211dGlyYW9rdWJlcm5ldGVz

# loadtest

kubectl run -i -n core --tty core-load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://core-application.core:8080/patients/findByGivenName?givenName=S; done"
kubectl run -i -n core --tty catalog-load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://catalog-application.core:8080/insurances/findByDisplay?display=a; done"


kubectl run -i -n core --tty core-all --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do \
wget -q -O- http://core-application.core:8080/patients/findByGivenName?givenName=S && \
wget -q -O- http://catalog-application.core:8080/insurances/findByDisplay?display=a; done"
