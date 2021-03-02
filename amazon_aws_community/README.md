# lucidum-deployment-seed `amazon_aws_community`


0. Contact Lucidum Sales:
   - Lucidum Community License Key: needed to unlock Lucidum UI

1. Set variables in `terraform.tfvars`

2. Download and install terraform https://www.terraform.io/downloads.html

3. Configure amazon cloud credentials https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

4. Execute `terraform init`

5. Execute `terraform apply`



### AWS cross account assume role

`x_account_assume_role` directory for child account stack execution

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_assume_role` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)
