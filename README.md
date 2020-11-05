# lucidum-ami-deployment-seed

- set variables is `terraform.tfvars`

- set secrets in boot script `boot_[*].sh`

- execute `terraform init` and `terraform apply`



### AWS cross account assume role

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_assume_role` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-ami-deployment-seed/blob/master/assume-role.jpg?raw=true)
