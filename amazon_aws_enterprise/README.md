# lucidum-deployment-seed `amazon_aws_enterprise`

0. Contact Lucidum Support (support@lucidum.io).  Lucidum support will securely provide you with an AWS key.
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
     Provide us with your GPG public key and we will use it to encrypt and send you encrypted secrets\
     You can download GPG tools here: https://gnupg.org/

1. Clone this repo to your local workstation.
   - `git clone https://github.com/LucidumInc/lucidum-deployment-seed.git`

2. Set variables in `terraform.tfvars`
   - These are your AWS account specific values, such as vpc, subnet ids, ssh key, etc.

3. Set the AWS Secrets (from step 0) in the boot script `amazon_aws_enterprise/boot_ubuntu18.sh`.  NOTE: Ubuntu is the default, but you can also choose Amazon Linux.  *If you prefer Amazon Linux, instead directly edit the Amazon Linux boot script at `boot_scripts/boot_amznlinux2.sh`*
   - These are the customer specific encrypted secrets we will provide you from step 0.
   - Decrypt file with GPG tools `gpg --decrypt customer.asc`
   - The file will contain three parameters to set in your boot script: CUSTOMER_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY.  The boot scripts already contain placeholders for the information, just set the 3 values in the variable.

4. Download and install terraform https://www.terraform.io/downloads.html
   - Please ensure Terraform version 0.14.7 is installed
   - Hashicorp provides precompiled Go executables for Terraform

5. Configure amazon cloud credentials https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
   - install python `awscli` package (rpm/deb/pip/venv)
   - configure awscli default profile `aws configure`
   - awscli default profile should be set to the AWS account that you will deploy the Lucidum server to

6. Execute Terraform
   - `terraform init`
   - `terraform apply`

7. Lucidum instance will be deployed to your AWS account, and you will be ready to configure data connectors.


### AWS cross account assume role

`x_account_deployment` directory for child account stack execution

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_deployment` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)
