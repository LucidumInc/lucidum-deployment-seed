#!/bin/bash

set -o errexit
#set -o xtrace
#set -o verbose


TRUST_ACCOUNT=123456789012
IDEMPOTENT_BUCKET=true
AWS_REGION=us-west-1
AWS_PROFILE=default
ROLE_NAME=lucidum_assume_role
STACK_NAME=lucidum-assume-role
STACK_TEMPLATE=lucidum_assume_role.cfn
S3_KEY=lucidum_assume_role_policy.json
S3_BUCKET=lucidum-assume-role-iam-policy-cfn
TRUST_EXTERNAL_ID=lucidum-access
ACCOUNT_NUMBER=$(aws sts get-caller-identity \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --query Account --output text 2> /dev/null)


if [ "${IDEMPOTENT_BUCKET}" == "true" ]; then
  S3_BUCKET=${S3_BUCKET}-$(date +%s)
fi


if ! aws s3 ls --region ${AWS_REGION} --profile ${AWS_PROFILE} s3://${S3_BUCKET} &> /dev/null; then

  echo create iam policy bucket
  aws s3api create-bucket \
    --profile ${AWS_PROFILE} \
    --bucket ${S3_BUCKET}
  sleep 5
fi


echo upload iam policy
aws s3api put-object \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --bucket ${S3_BUCKET} \
  --key ${S3_KEY} \
  --body ${S3_KEY}


echo deploy cloudformation
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
    echo "arn:aws:iam::${ACCOUNT_NUMBER}:role/${ROLE_NAME} - ROLE IS PRE-EXISTING (not under cloudformation control)"
    echo
    echo please delete and try again.
    echo
    exit 0
  fi
fi


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


aws cloudformation describe-stacks \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --stack-name ${STACK_NAME} \
  --query Stacks[0].Outputs


echo
echo lucidum aws cross-account cloudformation deployment COMPLETE
echo
