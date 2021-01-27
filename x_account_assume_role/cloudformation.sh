#!/bin/bash

set -o errexit
set -o errtrace


IDEMPOTENT_BUCKET=false
AWS_REGION=us-west-1
AWS_PROFILE=default
TRUST_ACCOUNT=123456789012
S3_BUCKET=lucidum-iam-policy-cfn
S3_KEY=lucidum_assume_role_policy.json
STACK_NAME=lucidum-assume-role
STACK_TEMPLATE=lucidum_assume_role.cfn
EXISTING_STACKS=$(aws cloudformation list-stacks --query StackSummaries[*].StackName --output text 2> /dev/null)


if [ "${IDEMPOTENT_BUCKET}" == "true" ]; then
  S3_BUCKET=${S3_BUCKET}-$(date +%s)
fi


if ! aws s3 ls s3://${S3_BUCKET} &> /dev/null; then
  echo create iam policy bucket
  aws s3api create-bucket \
    --bucket ${S3_BUCKET}
fi


echo upload iam policy
aws s3api put-object \
  --bucket ${S3_BUCKET} \
  --key ${S3_KEY} \
  --body ${S3_KEY}


echo deploy cloudformation
if [ "*${STACK_NAME}*" == "${EXISTING_STACKS}" ]; then
  echo cloudformation stack ${STACK_NAME} exists. please clean and try again.

else
  aws cloudformation deploy \
    --region ${AWS_REGION} \
    --profile ${AWS_PROFILE} \
    --template-file ${STACK_TEMPLATE} \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
      TrustAccount=${TRUST_ACCOUNT} \
      S3Bucket=${S3_BUCKET} \
      S3Key=${S3_KEY}
fi
