# lucidum-deployment-seed `microsoft_azure`

To bring up the Lucidum stack on Microsoft Azure:

  0. Log into Azure CLI
     - Install Azure CLI https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
     - Execute `az login`

  1. Replace `azure.pub` with authorized public key for use by vm
     - This is the public key, matching your private key used to ssh into vm (step #4)

  2. Update variables in `terraform.tfvars`
     - These are your Azure specific values, such as instance size and deployment location
     - `trusted_locations` must be set to your public IP

  3. Download and install Terraform https://www.terraform.io/downloads.html
     - Please ensure latest Terraform version is installed
     - Hashicorp provides precompiled Go executables for Terraform

  4. Execute Terraform deployment
     - `terraform init`
     - `terraform apply`
     - Your lucidum-instance-public-IP will display at end of Terraform run (use this for step #4)

  5. Connect to instance `ssh -i /path/to/private_key ubuntu@[lucidum-instance-public-IP]`

  6. Update secrets in install script `/var/lib/cloud/instance/scripts/part-001`
     - These are the customer specific encrypted secrets we will provide you
     - We will provide you with these secrets as cyphertext asc file
     - Decrypt file with GPG tools `gpg --decrypt customer.asc`

  7. Execute install script `bash -ex /var/lib/cloud/instance/scripts/part-001`

  * Azure Key Vault may be able automate secrets injection. (steps 4-6).
  ** this may be similar to how Amazon does it with SSM ParameterStore,
     IAM Instance Profile and EC2 Cloudinit integration.
