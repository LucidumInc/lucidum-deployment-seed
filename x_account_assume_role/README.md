# role creation to execute in child accounts

.

### execute on cli or in loop
`terraform apply -var aws_profile=[$aws_child_account] -var trust_account=[$aws_main_account]`


.

### use config file
edit `terraform.tfvars` to set variables and `terraform apply`


.


.
# assume role architecture diagram


![alt text](https://github.com/LucidumInc/lucidum-ami-deployment-seed/blob/master/assume-role.jpg?raw=true)
