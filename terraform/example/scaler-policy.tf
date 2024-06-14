# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
# kubectl get hpa person-service-application --watch -n example

resource "kubernetes_manifest" "callee-service-application-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: callee-service-application
    namespace: example
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 50
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: callee-service-application
    behavior:
      scaleDown:
        stabilizationWindowSeconds: 30
        selectPolicy: Max
        policies:
          - type: Percent
            value: 100
            periodSeconds: 15
  EOF
  )
}

resource "kubernetes_manifest" "person-service-application-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: person-service-application
    namespace: example
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 50
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: person-service-application
    behavior:
      scaleDown:
        stabilizationWindowSeconds: 30
        selectPolicy: Max
        policies:
          - type: Percent
            value: 100
            periodSeconds: 15
  EOF
  )
}
