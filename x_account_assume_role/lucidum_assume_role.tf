provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_iam_policy_document" "lucidum_assume_role_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ var.trust_account ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [ var.trust_external_id ]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lucidum_assume_role" {
  name               = var.stack_name
  assume_role_policy = data.aws_iam_policy_document.lucidum_assume_role_trust.json
}

resource "aws_iam_role_policy" "lucidum_assume_role_trust" {
  name   = var.stack_name
  role   = aws_iam_role.lucidum_assume_role.name
  policy = data.aws_iam_policy_document.lucidum_assume_role_policy.json
}

data "aws_iam_policy_document" "lucidum_assume_role_policy" {
  statement {
    sid = "1"
    resources = [ "*" ]
    actions = [
                "cloudtrail:Describe*",
                "cloudtrail:Get*",
                "cloudtrail:List*",
                "cloudtrail:LookupEvents",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "config:Describe*",
                "config:Get*",
                "config:List*",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "dynamodb:Scan",
                "ec2:Describe*",
                "ec2:Get*",
                "ecs:Describe*",
                "ecs:List*",
                "eks:Describe*",
                "eks:List*",
                "elasticloadbalancing:Describe*",
                "guardduty:Get*",
                "guardduty:List*",
                "iam:Get*",
                "iam:List*",
                "inspector:Describe*",
                "inspector:Get*",
                "inspector:List*",
                "kms:Describe*",
                "kms:Get*",
                "kms:List*",
                "lambda:Get*",
                "lambda:List*",
                "pricing:Describe*",
                "pricing:Get*",
                "route53:List*",
                "s3:Get*",
                "s3:List*",
                "securityhub:Describe*",
                "securityhub:Get*",
                "securityhub:List*",
                "ssm:Get*",
                "sts:Get*",
                "tag:Get*",
    ]
  }
}

output "lucidum_role_arn" {
  value = aws_iam_role.lucidum_assume_role.arn
}
