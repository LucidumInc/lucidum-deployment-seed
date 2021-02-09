# Lucidum deployment seed


This repository contains the necessary code to boot Lucidum product accross multiple cloud providers.

`amazon_aws` provides code to boot on amazon cloud

`google_compute` provides code to boot on google cloud

`microsoft_azure` provides code to boot on microsoft cloud


### AWS cross account assume role

`x_account_assume_role` directory for sub-account stack execution

- main-account supports assume role by default and requires no additional action.
  * main-account terraform assume role resources created automatically as part of main stack.
  * main-account trusts itself and is treated like sub-accounts.

- sub-accounts require additional configuration step.
  * each sub-account must execute terraform in `x_account_assume_role` subdirectory as terraform root.

- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)


### AWS cross account assume role batch script

`x_account_assume_role.sh` will allow the creation of roles accross multiple AWS accounts in batch mode. This script will iterate thru a list of AWS CLI profiles, and execute the necessary Terraform (default) or Cloudformation in each subaccount.

`x_account_assume_role.sh` will execute in Terraform mode by default. If Cloudformation mode is prefered, add the `cloudformation` argument to the script, such as: `bash x_account_assume_role.sh cloudformation`. NOTE: Cloudformation does not cleanly cleanup on failures, so may need to clean up cfn stacks in subaccounts on failures, such as due to erroneous TRUST_ACCOUNT value.
