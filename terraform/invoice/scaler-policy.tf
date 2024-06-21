# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
# kubectl get hpa redis-node --watch -n invoice

resource "kubernetes_manifest" "redis-node-autoscaler" {
  manifest   = yamldecode(<<-EOF
  apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    name: redis-node
    namespace: invoice
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 15
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: StatefulSet
      name: redis-node
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
