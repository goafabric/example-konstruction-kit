# basics

- every application helm chart with multi tenancy has an extra folder "provisioning"
- this contains a job with "-migrate -terminate" as well as the original configmap (and secrets)
- list of tenants is stored inside "helm/values.yaml" and supplied to all processes (SSOT)
- will work for both terraform and argocd, however for argocd updating values.yaml might undesired trigger normal application cycle

# schema creation for new tenants

- occurs outside the normal helm application lifecycle by
  - adding a new tenant to "helm/values.yaml"
  - by calling all provisioning jobs inside "tenant-prov", which will create the new schema for new tenants
  - ensures no downtime of running applications and will also not interfere because its just schemas for new tenants not in use 

# schema update for existing tenants

- is kept within the existing helm application lifecycle on application startup 
  - to ensure consistency between application, version and adherent flyway scripts
- will leverage the tenants previously added to "helm/values.yaml"
- works for up to 100 tenants (startup times < 3s), breaks with 1000 tenants (startup times > 10s)
