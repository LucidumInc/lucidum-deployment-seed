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
      "Sid": "ec2detection"
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
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "iam:PassRole",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.lucidum_s3_bucket}/*",
      "Effect": "Allow"
    },
    {
      "Action": "ec2:DescribeInstances",
      "Resource": "*",
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
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.us-east-1
  }
}

module "ec2_detection_us_east_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.us-east-2
  }
}

module "ec2_detection_us_west_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.us-west-1
  }
}

module "ec2_detection_us_west_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.us-west-2
  }
}

module "ec2_detection_ca_central_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ca-central-1
  }
}

module "ec2_detection_eu_north_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.eu-north-1
  }
}

module "ec2_detection_eu_west_3" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.eu-west-3
  }
}

module "ec2_detection_eu_west_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.eu-west-2
  }
}

module "ec2_detection_eu_west_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.eu-west-1
  }
}

module "ec2_detection_eu_central_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.eu-central-1
  }
}

module "ec2_detection_ap_south_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ap-south-1
  }
}

module "ec2_detection_ap_northeast_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ap-northeast-1
  }
}

module "ec2_detection_ap_northeast_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ap-northeast-2
  }
}

module "ec2_detection_ap_southeast_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ap-southeast-1
  }
}

module "ec2_detection_ap_southeast_2" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.ap-southeast-2
  }
}

module "ec2_detection_sa_east_1" {
  count                   = var.ec2_detection ? 1 : 0
  source                  = "./lambda_functions/ec2_detection"
  lambda_log_group_prefix = var.lambda_log_group_prefix
  stack_prefix            = local.ec2_detect_prefix
  environment             = var.environment
  execution_role_arn      = aws_iam_role.ec2_detection[0].arn
  s3_bucket               = var.lucidum_s3_bucket
  providers = {
    aws = aws.sa-east-1
  }
}
