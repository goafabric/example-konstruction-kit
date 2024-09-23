# links

- Vault Intro https://youtu.be/2Owo4Ioo9tQ?si=mFLEmPVjeBn8-Cm4
  - https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/hashicorp/vault-2022/example-apps/basic-secret
- Postgres Vault: https://youtu.be/IWCOptiCKqI?si=8TueYTixGk1NS5S2
- Baeldung (with Operator): https://www.baeldung.com/spring-vault-kubernetes-secrets
                                                          
# Possibilites
- Without Vault Operator, secrets are written to files but not env
- For Spring Applications, read Props from prepared application.properties
- For Postgres, Plugin could be used that reverses everything by creatung users from vault -> postgres
- FOr all Other Apps (kafka, redis) ?
- => Alternative use the Vault Operator, that can sync to secrets (security issue if secrets are not encrypted)

# Challenges

- Vault has to be unsealed, DevMode as Workaround
- For Terraform Vault needs to be exposed via Nodeport + Password ?
- 