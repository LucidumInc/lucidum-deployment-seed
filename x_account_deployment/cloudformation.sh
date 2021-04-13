#!/bin/bash

set -o errexit
#set -o xtrace
#set -o verbose


echo "##################################################"
echo "#                                                #"
echo "#             lucidum iam policy                 #"
echo "#           cloudformation wrapper               #"
echo "#                                                #"
echo "#                                                #"
echo "#           @nand0p - January 2021               #"
echo "#                                                #"
echo "##################################################"


TRUST_ACCOUNT=308025194586
IDEMPOTENT_RUN=true
AWS_REGION=us-west-1
ROLE_NAME=lucidum_assume_role
STACK_NAME=lucidum-assume-role
STACK_TEMPLATE=lucidum_assume_role.cfn
S3_KEY=lucidum_assume_role_policy.json
S3_BUCKET=lucidum-assume-role-iam-policy-cfn
TRUST_EXTERNAL_ID=lucidum-access
ROLE_ARN_FILE=lucidum_assume_role_arn.txt


echo set aws profile if passed
if [ "$1" != "" ]; then
  AWS_PROFILE=$1
else
  AWS_PROFILE=default
fi
echo running with aws profile ${AWS_PROFILE}


ACCOUNT_NUMBER=$(aws sts get-caller-identity \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --query Account \
  --output text 2> /dev/null)


if [ "${IDEMPOTENT_RUN}" == "true" ]; then
  echo dont fail on existing policy bucket
  S3_BUCKET=${S3_BUCKET}-$(date +%s)
fi


echo check policy bucket exists
if ! aws s3 ls s3://${S3_BUCKET} \
   --region ${AWS_REGION} \
   --profile ${AWS_PROFILE} &> /dev/null; then

  echo create iam policy bucket
  aws s3 mb s3://${S3_BUCKET} \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE}
  sleep 5
fi


echo upload iam policy
aws s3api put-object \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --bucket ${S3_BUCKET} \
  --key ${S3_KEY} \
  --body ${S3_KEY}


echo check stack exists
if aws cloudformation describe-stacks \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --stack-name ${STACK_NAME} &> /dev/null; then
  echo role under cloudformation control

else
  if aws iam get-role \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE} \
    --role-name ${ROLE_NAME} &> /dev/null; then

    echo
    echo "arn:aws:iam::${ACCOUNT_NUMBER}:role/${ROLE_NAME} - ROLE IS PRE-EXISTING (not under cloudformation control)" | tee ${ROLE_ARN_FILE}
    echo
    echo please delete and try again.
    echo
    exit 0
  fi
fi


echo deploy cloudformation
aws cloudformation deploy \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --template-file ${STACK_TEMPLATE} \
  --stack-name ${STACK_NAME} \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    TrustAccount=${TRUST_ACCOUNT} \
    S3Bucket=${S3_BUCKET} \
    S3Key=${S3_KEY} \
    TrustExternalId=${TRUST_EXTERNAL_ID} \
    AssumeRoleName=${ROLE_NAME} || true


echo clean s3
if [ "${IDEMPOTENT_RUN}" == "true" ]; then
  aws s3 rm --recursive s3://${S3_BUCKET} \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE}
  aws s3 rb s3://${S3_BUCKET} \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE}
fi


echo verify stack
aws cloudformation describe-stacks \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --stack-name ${STACK_NAME} \
  --query Stacks[0].Outputs


echo output arn file
echo "arn:aws:iam::${ACCOUNT_NUMBER}:role/${ROLE_NAME}" | \
  tee ${ROLE_ARN_FILE}


echo
echo lucidum aws cross-account cloudformation deployment COMPLETE
echo
