# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
# kubectl get hpa core-application --watch -n core
# kubectl get hpa catalog-application --watch -n core

resource "kubernetes_manifest" "core-application-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: core-application
    namespace: core
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
      name: core-application
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

resource "kubernetes_manifest" "catalog-application-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: catalog-application
    namespace: core
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 40
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: catalog-application
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
