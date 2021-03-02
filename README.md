# Lucidum deployment seed


This repository contains the necessary code to boot Lucidum product across multiple cloud providers.

`amazon_aws_community` provides code to boot Community Lucidum version on Amazon cloud

`amazon_aws_enterprise` provides code to boot Enterprise Lucidum version on Amazon cloud

`google_compute` provides code to boot Enterprise Lucidum on Google cloud

`microsoft_azure` provides code to boot Enterprise Lucidum on Microsoft cloud

`boot_scripts` used by Terraform / Cloudformation / On-Premises (VMware, OpenStack, etc) 


### AWS cross account assume role

`x_account_assume_role` directory for sub-account stack execution.

- Terraform and Cloudformation support in `x_account_assume_role` subdirectory
  * Role is created in subaccounts with proper IAM Role and Policy
  * Terraform support via `terraform [init|apply]`
  * Cloudformation support via cfn wrapper `bash cloudformation.sh`

- Main-account supports iam policy by default and requires no additional action.
  * Main-account iam instance role resources created automatically as part of main stack.
  * Main-account trust itself and may be treated like sub-accounts.


- cross account assume role diagram:
![alt text](https://github.com/LucidumInc/lucidum-deployment-seed/blob/master/assume-role.jpg?raw=true)


### AWS cross account assume role batch script

`x_account_assume_role.sh` will allow the creation of roles accross multiple AWS accounts in batch mode. This script will iterate thru a list of AWS CLI profiles, and execute the necessary Terraform (default) or Cloudformation in each subaccount.

`x_account_assume_role.sh` will execute in Terraform mode by default. If Cloudformation mode is prefered, add the `cloudformation` argument to the script, such as: `bash x_account_assume_role.sh cloudformation`. NOTE: Cloudformation does not cleanly cleanup on failures, so may need to clean up cfn stacks in subaccounts on failures, such as due to erroneous TRUST_ACCOUNT value.


### System Resources

We recommend the following minimum resources:
`memory 128G`
`cpu 16 cores`
`hard drive 1T SSD`
