#!/bin/bash


AWS_REGION=
AWS_PROFILE=
TRUST_ACCOUNT=123456789012


aws cloudformation deploy \
  --region ${AWS_REGION} \
  --profile ${AWS_PROFILE} \
  --template-file lucidum_assume_role.cfn \
  --stack-name lucidum-assume-role \
  --parameter-overrides TrustAccount=${TRUST_ACCOUNT} \
  --capabilities CAPABILITY_NAMED_IAM
