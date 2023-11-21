# command
terraform init
terraform plan
terraform apply
terraform destroy

# variables
certain variables like server_arch have to be set from outside, you can "source .values" for that

# todos
- secrets
- hostname + architecture from configmap https://itnext.io/manage-auto-generated-secrets-in-your-helm-charts-5aee48ba6918, https://stackoverflow.com/questions/59584420/how-to-define-global-variables-in-terraform
- keycloak
- volume encryption