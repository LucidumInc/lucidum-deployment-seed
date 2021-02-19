# lucidum-deployment-seed `amazon_aws`

0. set variables in `terraform.tfvars`

1. set secrets in boot script `boot_[*].sh` when not community edition
   ** to obtain secrets for enterprise edition, please contact Lucidum **

2. download and install terraform https://www.terraform.io/downloads.html

3. configure amazon cloud credentials https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

4. execute `terraform init`

5. execute `terraform apply`



### AWS cross account assume role

`x_account_assume_role` directory for child account stack execution

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_assume_role` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)
