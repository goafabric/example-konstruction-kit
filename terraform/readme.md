# command
terraform init
terraform plan
terraform apply
terraform destroy

# variables
certain variables like server_arch have to be set from outside, you can "source .values" for that
           
# information 
- the workspaces isolate the different stage, as a workspace name the server name is used and will be injected from the outside
- local helm charts are used a ../../ .. it is of course also possible to load them via a helm registry, during development that saves one extra roundtrip
- cert-manager has an extra local helm chart .. because the depends_on used here is otherwise not working .. that's just a workaround for the kubernetes yaml plugin
- all other yaml files are imported via the file + yamldecode((EOF ...) .. there is the option to use native HCL Syntax ChatGPT on a good that can convert that .. but to my eyes it looks even less readable and more bloated
- The excpetion is the ArgoCD Defintions, these are using HCL Syntax .. because there it made sense