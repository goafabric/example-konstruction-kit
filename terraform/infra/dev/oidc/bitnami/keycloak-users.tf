# tenant 0

resource "keycloak_realm" "tenant-0" {
  depends_on = [helm_release.keycloak]
  realm   = "tenant-0"
  enabled = true

  password_policy = "length(10) and maxLength(64) and upperCase(1) and lowerCase(1) and digits(1)"

  /*
  security_defenses {
    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 5
      wait_increment_seconds           = 60
    }
  }
  */
}

resource "keycloak_openid_client" "openid_client_0" {
  realm_id  = keycloak_realm.tenant-0.id
  client_id = "oauth2-proxy"
  client_secret = "none"

  name    = "oauth2-proxy"
  enabled = true

  access_type = "PUBLIC"
  standard_flow_enabled = true
  direct_access_grants_enabled = true
  valid_redirect_uris = [ "*" ]
  valid_post_logout_redirect_uris = [ "+" ]
}

resource "keycloak_user" "user1_0" {
  realm_id   = keycloak_realm.tenant-0.id
  username   = "user1"
  first_name = "user1"
  last_name  = "user1"
  enabled    = true

  email      = "user1@example.com"
  email_verified = true

  initial_password {
    value     = "User1user1"
    temporary = false
  }
}

resource "keycloak_user" "user2_0" {
  realm_id   = keycloak_realm.tenant-0.id
  username   = "user2"
  first_name = "user2"
  last_name  = "user2"
  enabled    = true

  email      = "user2@example.com"
  email_verified = true

  initial_password {
    value     = "User2user2"
    temporary = false
  }
}

# tenant 5

resource "keycloak_realm" "tenant-5" {
  depends_on = [helm_release.keycloak]
  realm   = "tenant-5"
  enabled = true

  password_policy = "length(10) and maxLength(64) and upperCase(1) and lowerCase(1) and digits(1)"

  /*
  security_defenses {
    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 5
      wait_increment_seconds           = 60
    }
  }
  */
}

resource "keycloak_openid_client" "openid_client_5" {
  realm_id  = keycloak_realm.tenant-5.id
  client_id = "oauth2-proxy"
  client_secret = "none"

  name    = "oauth2-proxy"
  enabled = true

  access_type = "PUBLIC"
  standard_flow_enabled = true
  direct_access_grants_enabled = true
  valid_redirect_uris = [ "*" ]
  valid_post_logout_redirect_uris = [ "+" ]
}

resource "keycloak_user" "user1_5" {
  realm_id   = keycloak_realm.tenant-5.id
  username   = "user1"
  first_name = "user1"
  last_name  = "user1"
  enabled    = true

  email      = "user1@example.com"
  email_verified = true

  initial_password {
    value     = "User1user1"
    temporary = false
  }
}

resource "keycloak_user" "user2_5" {
  realm_id   = keycloak_realm.tenant-5.id
  username   = "user2"
  first_name = "user2"
  last_name  = "user2"
  enabled    = true

  email      = "user2@example.com"
  email_verified = true

  initial_password {
    value     = "User2user2"
    temporary = false
  }
}