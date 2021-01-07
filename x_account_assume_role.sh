#!/bin/bash -e


# Set aws profiles to loop thru for creating assume role in sub-accounts
AWS_PROFILES="
  awscli-profile-1
  awscli-profile-2
"

# Set this to "true" for non-interactive execution
AUTO_APPROVE=false


echo ensure prereqs are installed
terraform --version
aws --version

echo set script variables
BASE_DIR=$(pwd)
TEMPLATE_FILES="
  lucidum_assume_role.tf
  lucidum_assume_role_policy.json
  terraform.tfvars variables.tf
  variables.tf
"

for AWS_PROFILE in ${AWS_PROFILES}; do

  echo test aws profile
  aws --profile ${AWS_PROFILE} sts get-caller-identity

  echo test terraform iteration root does not exist
  if [ -d "x_account_assume_role_${AWS_PROFILE}" ]; then
    echo terraform root exists. please remove directory x_account_assume_role_${AWS_PROFILE}
    exit 1
  else
    echo OK
  fi

  echo create iteration template directory
  mkdir -v ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}

  echo copy iteration template to x_account_assume_role_${AWS_PROFILE}
  for TEMPLATE_FILE in ${TEMPLATE_FILES}; do
    rm -fv ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/${TEMPLATE_FILE}
    cp -v ${BASE_DIR}/x_account_assume_role/${TEMPLATE_FILE} \
      ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/${TEMPLATE_FILE}
  done

  echo set iteration profile name
  echo "aws_profile = \"${AWS_PROFILE}\"" | tee -a ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/terraform.tfvars

  echo initialize terraform
  cd ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}
  terraform init

  echo execute terraform
  if [ "${AUTO_APPROVE}" == "true" ]; then
    terraform apply --auto-approve
  else
    terraform apply || true
  fi
done

echo -e "\n\nLucidum subaccount role processed for the following aws profiles:"
echo -e "\n${AWS_PROFILES}\n\n"
