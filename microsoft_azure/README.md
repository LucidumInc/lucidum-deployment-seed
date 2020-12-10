To bring up the Lucidum stack on Microsoft Azure:

  1. log into Azure CLI

  2. execute deployment: `terraform init` and `terraform apply`

  3. connect to instance: `ssh -i /path/to/key ubuntu@{{ public_ip }}`

  4. update secrets in install script: `/var/lib/cloud/instance/scripts/part-001`

  5. execute install script: `bash -ex /var/lib/cloud/instance/scripts/part-001`

  * Azure Key Vault may be able automate secrets injection. (steps 3-5).
  ** this may be similar to how Amazon does it with SSM ParameterStore,
     IAM Instance Profile and Cloudinit integration.
