# lucidum-deployment-seed `amazon_aws_enterprise`


0. Contact Lucidum Sales:\
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
     Provide us with your GPG public key and we will use it to encrypt and send you encrypted secrets\
     You can download GPG tools here: https://gnupg.org/

1. Set variables in `terraform.tfvars`
   - These are your AWS account specific values, such as vpc and subnet ids.

2. Set Enterprise AWS Secrets in boot script `boot_ubuntu18.sh`
   - These are the customer specific encrypted secrets we provide you

3. Download and install terraform https://www.terraform.io/downloads.html
   - Hashicorp provides precompiled Go executables for Terraform

4. Configure amazon cloud credentials https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
   - awscli default profile should be set to account to deploy Lucidum
   - awscli profile can be overriden in Terraform variables for advanced users

5. Execute `terraform init`

6. Execute `terraform apply`

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
