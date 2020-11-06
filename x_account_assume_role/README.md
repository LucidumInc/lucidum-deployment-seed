# role creation to execute in child accounts

.

## terraform

.

### execute on cli
`terraform apply -var aws_region=${AWS_REGION} -var aws_profile=${AWS_CHILD_ACCOUNT} -var trust_account=${AWS_MAIN_ACCOUNT}`

.

### use config file
edit `terraform.tfvars` to set variables and `terraform apply`

.

.

## cloudformation

### set vars and execute
edit `clouformation.sh` to set variables and `bash cloudformation.sh`

.

.

# assume role architecture diagram


![alt text](https://github.com/LucidumInc/lucidum-ami-deployment-seed/blob/master/assume-role-002.jpg?raw=true)
