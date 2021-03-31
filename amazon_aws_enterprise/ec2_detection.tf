provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

locals {
  ec2_detect_prefix = "lucidum-ec2-detection-${var.environment}"
}

resource "aws_iam_role" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  name        = local.ec2_detect_prefix
  description = local.ec2_detect_prefix

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  name        = local.ec2_detect_prefix
  description = local.ec2_detect_prefix
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_detection" {
  count      = var.ec2_detection ? 1 : 0
  role       = aws_iam_role.ec2_detection[0].name
  policy_arn = aws_iam_policy.ec2_detection[0].arn
}

module "ec2_detection_us_east_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  ec2_detection           = var.ec2_detection
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  providers = {
    aws = aws.us-east-1
  }
}

module "ec2_detection_us_east_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  ec2_detection           = var.ec2_detection
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  providers = {
    aws = aws.us-east-2
  }
}

module "ec2_detection_us_west_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  ec2_detection           = var.ec2_detection
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  providers = {
    aws = aws.us-west-1
  }
}

module "ec2_detection_us_west_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  ec2_detection           = var.ec2_detection
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  providers = {
    aws = aws.us-west-2
  }
}
