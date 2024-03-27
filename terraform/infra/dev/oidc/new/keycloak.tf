resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "18.4.0"
  namespace  = "oidc"
  timeout    = "600"
  create_namespace = true

  set {
    name  = "auth.adminUser"
    value = "admin"
  }

  set {
    name  = "auth.adminPassword"
    value = "admin" #random_password.keycloak_admin_password.result
  }

  set {
    name  = "postgresql.auth.password"
    value = random_password.keycloak_database_non_admin_password.result
  }

  set {
    name  = "postgresql.auth.postgresPassword"
    value = random_password.keycloak_database_admin_password.result
  }

  set {
    name  = "extraEnvVars[0].name"
    value = "TZ"
  }

  set {
    name  = "extraEnvVars[0].value"
    value = "Europe/Berlin"
  }

  set {
    name  = "extraEnvVars[1].name"
    value = "KEYCLOAK_HTTP_RELATIVE_PATH"
  }

  set {
    name  = "extraEnvVars[1].value"
    value = "/oidc"
  }

  set {
    name  = "extraEnvVars[2].name"
    value = "KC_PROXY"
  }

  set {
    name  = "extraEnvVars[2].value"
    value = "edge"
  }

  set {
    name  = "extraEnvVars[3].name"
    value = "KC_HOSTNAME_STRICT"
  }

  set {
    name  = "extraEnvVars[3].value"
    value = "false"
    type  = "string"
  }

  set {
    name  = "extraEnvVars[4].name"
    value = "KC_HOSTNAME"
  }

  set {
    name  = "extraEnvVars[4].value"
    value = var.hostname
  }

  set {
    name  = "readinessProbe.enabled"
    value = "false"
  }

  set {
    name  = "livenessProbe.enabled"
    value = "false"
  }

  set {
    name  = "customReadinessProbe"
    value = <<-EOF
    httpGet:
      path: /oidc/realms/master
      port: 8080
    initialDelaySeconds: 5
    EOF
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=keycloak -n oidc"
  }
}

resource "random_password" "keycloak_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_database_non_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_database_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "keycloak_client_secret" {
  length  = 32
  special = false
}