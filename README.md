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
