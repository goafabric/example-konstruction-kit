# div
- kong oidc

## security
- secrets via vault
- volume encryption
- rbac                                                                                                               k
                                                                                               
# info
- 10 best practices: https://www.youtube.com/watch?app=desktop&v=oBf5lrmquYI&pp=ygUSI211dGlyYW9rdWJlcm5ldGVz

                                                       
# scale
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
kubectl autoscale deployment person-service-application -n example --cpu-percent=20 --min=1 --max=5
kubectl get hpa person-service-application --watch -n example