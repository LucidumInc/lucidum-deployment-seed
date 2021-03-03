# lucidum-deployment-seed `amazon_aws_enterprise`


0. Contact Lucidum Sales:
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
     Provide us with your GPG public key and we will use it to encrypt and send you encrypted secrets\
     You can download GPG tools here: https://gnupg.org/

1. Clone this repo to your local workstation.
   - `git clone https://github.com/LucidumInc/lucidum-deployment-seed.git`

2. Set variables in `terraform.tfvars`
   - These are your AWS account specific values, such as vpc and subnet ids.

3. Set Enterprise AWS Secrets in boot script `boot_ubuntu18.sh`
   - These are the customer specific encrypted secrets we will provide you
   - We will provide you with these secrets as cyphertext asc file.
   - Decrypt file with GPG tools `gpg --decrypt customer.asc`

4. Download and install terraform https://www.terraform.io/downloads.html
   - Please ensure Terraform version 0.14.7 is installed
   - Hashicorp provides precompiled Go executables for Terraform

5. Configure amazon cloud credentials https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
   - install python `awscli` package (rpm/deb/pip/venv)
   - configure awscli default profile `aws configure`
   - awscli default profile should be set to account to deploy Lucidum
   - awscli profile can be overriden in Terraform variables for advanced users

6. Execute Terraform
   - `terraform init`
   - `terraform apply`

7. Lucidum instance is up and ready to configure data connectors.


### AWS cross account assume role

`x_account_assume_role` directory for child account stack execution

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_assume_role` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)
