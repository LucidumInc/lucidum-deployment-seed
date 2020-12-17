To bring up the Lucidum stack on Microsoft Azure:

  0. log into Azure CLI

  1. replace `azure.pub` with authorized public key for use by vm

  2. update variables in `terraform.tfvars`

  3. execute deployment `terraform init` and `terraform apply`

  4. connect to instance `ssh -i /path/to/key ubuntu@{{ public_ip }}`

  5. update secrets in install script `/var/lib/cloud/instance/scripts/part-001`

  6. execute install script `bash -ex /var/lib/cloud/instance/scripts/part-001`

  * Azure Key Vault may be able automate secrets injection. (steps 3-5).
  ** this may be similar to how Amazon does it with SSM ParameterStore,
     IAM Instance Profile and Cloudinit integration.
