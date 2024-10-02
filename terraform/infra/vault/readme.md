# setup
- setup has to be done in 2 steps
  - base will install the base vault + banzai webhook for environment injection
  - configure will setup up the required authentication and roles, 
    - for dev purposes it will write the unseal keys to ~./vault 
    - vault token also needs to be exported for terraform, should be an environment variable in gitlab ci
  - and will also install an example app right away 
- a more fully fledged example, with helm postgres can be found under terraform/example
- other examples can be found under ./example-apps for the vault injector and secret sync that we are not using
- vault survives a server restart but no forceful pod kill, as it seems to loose the authentication information
  - in this case they need to be reconfigured, and also the applications might have to be redeployed
- ha mode + raft can be activated in helm chart

# Challenges
- Vault has to be unsealed, DevMode or Manual Unseal as Workaround, for Production Azure Auto Unseal
- For Terraform Vault needs to be exposed via Nodeport or we use kubcetl portforward in the deployment automation
- Secrets have to be put from the outside and stupid terraform puts them UNENCRYPTED into the statefile => opentofu ?
- All Application Deployments might need Init Container for Vault, or Vault is deployed to a seperate Server, othwise Pods could crash multiple times on server restart

# links
- Vault Intro https://youtu.be/2Owo4Ioo9tQ?si=mFLEmPVjeBn8-Cm4
  - https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/hashicorp/vault-2022/example-apps/basic-secret
- Postgres Vault: https://youtu.be/IWCOptiCKqI?si=8TueYTixGk1NS5S2
- Baeldung (with Operator): https://www.baeldung.com/spring-vault-kubernetes-secrets

# dev hacks
## vault unseal
$(grep "Unseal Key 1:" ~/.vault/seals-$TF_VAR_hostname | awk '{print $NF}') && kubectl exec vault-0 -n vault -- /bin/sh -c "vault operator unseal $vault_operator_unseal_key"

## vault token export
export VAULT_TOKEN=$(grep "Token:" ~/.vault/seals-$TF_VAR_hostname | awk '{print $NF}')