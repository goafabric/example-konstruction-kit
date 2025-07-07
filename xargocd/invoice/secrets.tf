resource "random_password" "cache_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

resource "kubernetes_secret" "redis_secret" {
  metadata {
    name      = "redis-secret"
    namespace = "invoice"
  }

  data = {
    "spring.data.redis.password" = random_password.cache_password.result

    #"spring.data.redis.sentinel.password" = random_password.redis_password.result
  }

  type = "Opaque"
}
