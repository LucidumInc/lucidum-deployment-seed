#!/bin/bash -e


# Set aws profiles to loop thru for creating assume role in sub-accounts

aws_profiles="lucidum lucidum-secondary"

# Set this to "true" for non-interactive execution
auto_approve=false


echo ensure terraform is installed
terraform --version

echo set base directory variable
base_dir=$(pwd)

for profile in ${aws_profiles}; do

  echo test aws profile
  aws --profile ${profile} sts get-caller-identity

  echo copy cross account template to x_account_assume_role_${profile}
  cp -r ${base_dir}/x_account_assume_role ${base_dir}/x_account_assume_role_${profile}

  echo set profile name
  sed -i '' 's/*aws_profile*/aws_profile=${profile}/' ${base_dir}/x_account_assume_role_${profile}/terraform.tfvars

  echo initialize terraform
  cd ${base_dir}/x_account_assume_role_${profile} 
  terraform init

  echo execute terraform
  if [ "${auto_approve}" == "true" ]; then
    terraform apply --auto-approve
  else
    terraform apply || true
  fi
done

echo -e "\n\nLucidum subaccount role processed for the following aws profiles:"
echo -e "\n${aws_profiles}\n\n"
