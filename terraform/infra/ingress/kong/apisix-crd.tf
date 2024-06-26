# resource "terraform_data" "destroy_crd" {
#   provisioner "local-exec" {
#     when    = create
#     command = "kubectl get crd apisixroutes.apisix.apache.org > /dev/null 2>&1 && kubectl delete crd apisixroutes.apisix.apache.org"
#   }
# }

resource "kubernetes_manifest" "apisix-fake-crsd" {
  manifest   = yamldecode(<<-EOF
  apiVersion: apiextensions.k8s.io/v1
  kind: CustomResourceDefinition
  metadata:
    name: apisixroutes.apisix.apache.org
  spec:
    group: apisix.apache.org
    scope: Namespaced
    names:
      plural: apisixroutes
      singular: apisixroute
      kind: ApisixRoute
      shortNames:
        - ar
    versions:
      - name: v2
        served: true
        storage: true
        subresources:
          status: {}
        additionalPrinterColumns:
          - jsonPath: .spec.http[].match.hosts
            name: Hosts
            type: string
          - jsonPath: .spec.http[].match.paths
            name: URIs
            type: string
          - jsonPath: .spec.http[].backends[].serviceName
            name: Target Service(HTTP)
            type: string
          - jsonPath: .spec.tcp[].match.ingressPort
            name: Ingress Server Port(TCP)
            type: integer
          - jsonPath: .spec.tcp[].match.backend.serviceName
            name: Target Service(TCP)
            type: string
          - jsonPath: .metadata.creationTimestamp
            name: Age
            type: date
        schema:
          openAPIV3Schema:
            type: object
            properties:
              spec:
                type: object
                anyOf:
                  - required: ["http"]
                  - required: ["stream"]
                properties:
                  ingressClassName:
                    type: string
                  http:
                    type: array
                    minItems: 1
                    items:
                      type: object
                      anyOf:
                        - required: ["name", "match", "backends"]
                        - required: ["name", "match", "upstreams"]
                      properties:
                        name:
                          type: string
                          minLength: 1
                        priority:
                          type: integer
                        timeout:
                          type: object
                          properties:
                            connect:
                              type: string
                            send:
                              type: string
                            read:
                              type: string
                        match:
                          type: object
                          required:
                            - paths
                          properties:
                            paths:
                              type: array
                              minItems: 1
                              items:
                                type: string
                            hosts:
                              type: array
                              minItems: 1
                              items:
                                type: string
                                pattern: "^\\*?[0-9a-zA-Z-._]+$"
                            methods:
                              type: array
                              minItems: 1
                              items:
                                type: string
                                enum:
                                  - "CONNECT"
                                  - "DELETE"
                                  - "GET"
                                  - "HEAD"
                                  - "OPTIONS"
                                  - "PATCH"
                                  - "POST"
                                  - "PUT"
                                  - "TRACE"
                            remoteAddrs:
                              type: array
                              minItems: 1
                              items:
                                type: string
                            exprs:
                              type: array
                              minItems: 1
                              items:
                                type: object
                                properties:
                                  subject:
                                    type: object
                                    properties:
                                      scope:
                                        type: string
                                        enum:
                                          - "Cookie"
                                          - "Header"
                                          - "Path"
                                          - "Query"
                                          - "Variable"
                                      name:
                                        type: string
                                        minLength: 1
                                    required:
                                      - scope
                                  op:
                                    type: string
                                    enum:
                                      - Equal
                                      - NotEqual
                                      - GreaterThan
                                      - GreaterThanEqual
                                      - LessThan
                                      - LessThanEqual
                                      - In
                                      - NotIn
                                      - RegexMatch
                                      - RegexNotMatch
                                      - RegexMatchCaseInsensitive
                                      - RegexNotMatchCaseInsensitive
                                  value:
                                    type: string
                                  set:
                                    type: array
                                    items:
                                      type: string
                                oneOf:
                                  - required: ["subject", "op", "value"]
                                  - required: ["subject", "op", "set"]
                            filter_func:
                              type: string
                        websocket:
                          type: boolean
                        plugin_config_name:
                          type: string
                          minLength: 1
                        plugin_config_namespace:
                          type: string
                          minLength: 1
                        upstreams:
                          description: Upstreams refer to ApisixUpstream CRD
                          type: array
                          items:
                            description: ApisixRouteUpstreamReference contains a ApisixUpstream
                              CRD reference
                            type: object
                            properties:
                              name:
                                type: string
                              weight:
                                type: integer
                        backends:
                          type: array
                          minItems: 1
                          items:
                            type: object
                            properties:
                              serviceName:
                                type: string
                                minLength: 1
                              servicePort:
                                anyOf:
                                  - type: integer
                                  - type: string
                                x-kubernetes-int-or-string: true
                              resolveGranularity:
                                type: string
                                enum: ["endpoint", "service"]
                              weight:
                                type: integer
                                minimum: 0
                              subset:
                                type: string
                          required:
                            - serviceName
                            - servicePort
                        plugins:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                                minLength: 1
                              enable:
                                type: boolean
                              config:
                                type: object
                                x-kubernetes-preserve-unknown-fields: true # we have to enable it since plugin config
                              secretRef:
                                type: string
                          required:
                            - name
                            - enable
                        authentication:
                          type: object
                          properties:
                            enable:
                              type: boolean
                            type:
                              type: string
                              enum:
                                - "basicAuth"
                                - "keyAuth"
                                - "jwtAuth"
                                - "wolfRBAC"
                                - "hmacAuth"
                                - "ldapAuth"
                            keyAuth:
                              type: object
                              properties:
                                header:
                                  type: string
                            jwtAuth:
                              type: object
                              properties:
                                header:
                                  type: string
                                query:
                                  type: string
                                cookie:
                                  type: string
                            ldapAuth:
                              type: object
                              properties:
                                base_dn:
                                  type: string
                                ldap_uri:
                                  type: string
                                use_tls:
                                  type: boolean
                                uid:
                                  type: string
                          required:
                            - enable
                  stream:
                    type: array
                    minItems: 1
                    items:
                      type: object
                      required: ["name", "match", "backend", "protocol"]
                      properties:
                        "protocol":
                          type: string
                          enum: ["TCP", "UDP"]
                        name:
                          type: string
                          minLength: 1
                        match:
                          type: object
                          properties:
                            host:
                              type: string
                            ingressPort:
                              type: integer
                              minimum: 1
                              maximum: 65535
                          required:
                            - ingressPort
                        backend:
                          type: object
                          properties:
                            serviceName:
                              type: string
                              minLength: 1
                            servicePort:
                              anyOf:
                                - type: integer
                                - type: string
                              x-kubernetes-int-or-string: true
                            resolveGranularity:
                              type: string
                              enum: ["endpoint", "service"]
                            subset:
                              type: string
                          required:
                            - serviceName
                            - servicePort
                        plugins:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                                minLength: 1
                              enable:
                                type: boolean
                              config:
                                type: object
                                x-kubernetes-preserve-unknown-fields: true # we have to enable it since plugin config
                              secretRef:
                                type: string
                          required:
                            - name
                            - enable
              status:
                type: object
                properties:
                  conditions:
                    type: array
                    items:
                      type: object
                      properties:
                        "type":
                          type: string
                        reason:
                          type: string
                        status:
                          type: string
                        message:
                          type: string
                        observedGeneration:
                          type: integer
  EOF
  )
}

