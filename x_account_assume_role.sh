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
X_ACCOUNT_ROLE_NAME=$(grep -A 2 stack_name ${BASE_DIR}/x_account_assume_role/variables.tf | tail -1 | cut -d'"' -f2)
TEMPLATE_FILES="
  lucidum_assume_role.tf
  lucidum_assume_role_policy.json
  terraform.tfvars variables.tf
  variables.tf
"
echo "
  base_dir:  ${BASE_DIR}
  role_name:  ${X_ACCOUNT_ROLE_NAME}
  template_files:  ${TEMPLATE_FILES}
"


echo remove any existing role arns file
rm -fv "${BASE_DIR}/x_account_assume_role_arns.txt"


for AWS_PROFILE in ${AWS_PROFILES}; do

  echo test aws profile
  aws --profile ${AWS_PROFILE} sts get-caller-identity

  echo create iteration template directory
  mkdir -pv "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}"

  echo copy iteration template to x_account_assume_role_${AWS_PROFILE}
  for TEMPLATE_FILE in ${TEMPLATE_FILES}; do
    rm -fv "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/${TEMPLATE_FILE}"
    cp -v "${BASE_DIR}/x_account_assume_role/${TEMPLATE_FILE}" \
      "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/${TEMPLATE_FILE}"
  done

  echo set iteration profile name
  echo "aws_profile = \"${AWS_PROFILE}\"" | tee -a "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/terraform.tfvars"

  echo change to subaccount terraform root
  cd "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}"

  echo initialize terraform
  terraform init

  echo check if ${X_ACCOUNT_ROLE_NAME} exists in aws profile ${AWS_PROFILE}
  if aws --profile ${AWS_PROFILE} iam get-role --role-name ${X_ACCOUNT_ROLE_NAME} 2> /dev/null && \
    ! grep ${X_ACCOUNT_ROLE_NAME} terraform.tfstate 2> /dev/null; then

    ACCOUNT_NUMBER=$(aws --profile ${AWS_PROFILE} sts get-caller-identity --query Account --output text)
    echo "arn:aws:iam::${ACCOUNT_NUMBER}:role/${X_ACCOUNT_ROLE_NAME} - ROLE IS PRE-EXISTING (not under terraform control)" | \
      tee "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/lucidum_assume_role_arn.txt"

  else
    echo execute terraform
    if [ "${AUTO_APPROVE}" == "true" ]; then
      terraform apply --auto-approve
    else
      terraform apply || true
    fi

  fi

  echo write out arn file ${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/lucidum_assume_role_arn.txt
  cat "${BASE_DIR}/x_account_assume_role_${AWS_PROFILE}/lucidum_assume_role_arn.txt" | \
    tee -a "${BASE_DIR}/x_account_assume_role_arns.txt"
  echo | tee -a "${BASE_DIR}/x_account_assume_role_arns.txt"

done

echo -e "\n\nLucidum subaccount roles created:"
cat "${BASE_DIR}/x_account_assume_role_arns.txt"
echo -e "\n\nLucidum assume role batch creation COMPLETE\n\n"
