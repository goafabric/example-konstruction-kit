# resource "terraform_data" "destroy_crd" {
#   provisioner "local-exec" {
#     when    = create
#     command = "k delete pod -l app.kubernetes.io/name=ingress-controller -n ingress-apisix"
#   }
# }

resource "kubernetes_manifest" "kong-fake-crsd" {
  manifest   = yamldecode(<<-EOF
  kind: CustomResourceDefinition
  apiVersion: apiextensions.k8s.io/v1
  metadata:
    name: kongplugins.configuration.konghq.com
  spec:
    group: configuration.konghq.com
    names:
      plural: kongplugins
      singular: kongplugin
      shortNames:
        - kp
      kind: KongPlugin
      listKind: KongPluginList
      categories:
        - kong-ingress-controller
    scope: Namespaced
    versions:
      - name: v1
        served: true
        storage: true
        schema:
          openAPIV3Schema:
            type: object
            required:
              - plugin
            properties:
              apiVersion:
                type: string
              config:
                type: object
                x-kubernetes-preserve-unknown-fields: true
              configFrom:
                type: object
                required:
                  - secretKeyRef
                properties:
                  secretKeyRef:
                    type: object
                    required:
                      - key
                      - name
                    properties:
                      key:
                        type: string
                      name:
                        type: string
              configPatches:
                type: array
                items:
                  type: object
                  required:
                    - path
                    - valueFrom
                  properties:
                    path:
                      type: string
                    valueFrom:
                      type: object
                      required:
                        - secretKeyRef
                      properties:
                        secretKeyRef:
                          type: object
                          required:
                            - key
                            - name
                          properties:
                            key:
                              type: string
                            name:
                              type: string
              consumerRef:
                type: string
              disabled:
                type: boolean
              instance_name:
                type: string
              kind:
                type: string
              metadata:
                type: object
              ordering:
                type: object
                properties:
                  after:
                    type: object
                    additionalProperties:
                      type: array
                      items:
                        type: string
                  before:
                    type: object
                    additionalProperties:
                      type: array
                      items:
                        type: string
              plugin:
                type: string
              protocols:
                type: array
                items:
                  type: string
                  enum:
                    - http
                    - https
                    - grpc
                    - grpcs
                    - tcp
                    - tls
                    - udp
              run_on:
                type: string
                enum:
                  - first
                  - second
                  - all
              status:
                type: object
                properties:
                  conditions:
                    type: array
                    maxItems: 8
                    items:
                      type: object
                      required:
                        - lastTransitionTime
                        - message
                        - reason
                        - status
                        - type
                      properties:
                        lastTransitionTime:
                          type: string
                          format: date-time
                        message:
                          type: string
                          maxLength: 32768
                        observedGeneration:
                          type: integer
                          format: int64
                          minimum: 0
                        reason:
                          type: string
                          maxLength: 1024
                          minLength: 1
                          pattern: ^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$
                        status:
                          type: string
                          enum:
                            - 'True'
                            - 'False'
                            - Unknown
                        type:
                          type: string
                          maxLength: 316
                          pattern: >-
                            ^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$
            x-kubernetes-validations:
              - rule: '!(has(self.config) && has(self.configFrom))'
                message: Using both config and configFrom fields is not allowed.
              - rule: '!(has(self.configFrom) && has(self.configPatches))'
                message: Using both configFrom and configPatches fields is not allowed.
              - rule: self.plugin == oldSelf.plugin
                message: The plugin field is immutable
        subresources:
          status: {}
        additionalPrinterColumns:
          - name: Plugin-Type
            type: string
            jsonPath: .plugin
          - name: Age
            type: date
            jsonPath: .metadata.creationTimestamp
          - name: Disabled
            type: boolean
            priority: 1
            jsonPath: .disabled
          - name: Config
            type: string
            priority: 1
            jsonPath: .config
          - name: Programmed
            type: string
            jsonPath: .status.conditions[?(@.type=="Programmed")].status
    conversion:
      strategy: None
  EOF
  )
}

