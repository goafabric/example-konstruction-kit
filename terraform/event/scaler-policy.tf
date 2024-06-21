# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
# kubectl get hpa event-dispatcher-service-application --watch -n event

resource "kubernetes_manifest" "event-dispatcher-service-application-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: event-dispatcher-service-application
    namespace: event
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 10
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: event-dispatcher-service-application
    behavior:
      scaleDown:
        stabilizationWindowSeconds: 30
        selectPolicy: Max
        policies:
          - type: Percent
            value: 100
            periodSeconds: 50
  EOF
  )
}
