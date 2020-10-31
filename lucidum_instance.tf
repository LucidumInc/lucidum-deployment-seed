provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


data "aws_ami" "lucidum_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [ "${var.lucidum_ami_version}*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ var.source_ami_account_number ]
}


resource "aws_security_group" "lucidum" {
  count       = var.security_group_id == "" ? 1 : 0
  name        = "${var.lucidum_ami_version}-${var.environment}"
  description = "${var.lucidum_ami_version}-${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    description = "debug icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.trusted_cidrs
  }

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  ingress {
    description = "allow connector endpoint"
    from_port   = 5500
    to_port     = 5501
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  ingress {
    description = "allow web ui"
    from_port   = 9080
    to_port     = 9080
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.lucidum_ami_version}-${var.environment}"
  }
}


locals {
  secgroup_id  = var.security_group_id != "" ? var.security_group_id : aws_security_group.lucidum[0].id
  profile_name = var.instance_profile_name != "" ? var.instance_profile_name : aws_iam_instance_profile.lucidum[0].name
}

resource "aws_instance" "lucidum" {
  ami                         = var.lucidum_ami_id == "" ? data.aws_ami.lucidum_ami.id : var.lucidum_ami_id
  instance_type               = var.instance_size
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [ local.secgroup_id ]
  iam_instance_profile        = local.profile_name
  availability_zone           = var.availability_zone
  user_data                   = file("boot_${var.boot_edition}.sh")

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "${var.lucidum_ami_version}-${var.environment}"
  }
}

resource "aws_volume_attachment" "lucidum_data" {
  count       = var.data_ebs_volume ? 1 : 0
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.lucidum_data[0].id
  instance_id = aws_instance.lucidum.id
}

resource "aws_volume_attachment" "lucidum_backup" {
  count       = var.backup_ebs_volume_id == "" ? 0 : 1
  device_name = "/dev/sdg"
  volume_id   = var.backup_ebs_volume_id
  instance_id = aws_instance.lucidum.id
}

resource "aws_ebs_volume" "lucidum_data" {
  count             = var.data_ebs_volume ? 1 : 0
  size              = 50
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.lucidum_ami_version}-${var.environment}_data"
  }
}

resource "aws_iam_instance_profile" "lucidum" {
  count = var.instance_profile_name == "" ? 1 : 0
  name  = "${var.lucidum_ami_version}-${var.environment}"
  role  = aws_iam_role.lucidum[0].name
}

resource "aws_iam_role" "lucidum" {
  count              = var.instance_profile_name == "" ? 1 : 0
  name               = "${var.lucidum_ami_version}-${var.environment}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lucidum_assume_role.json
  tags               = { Name = "${var.lucidum_ami_version}-${var.environment}" }
}

data "aws_iam_policy_document" "lucidum_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role_policy" "lucidum" {
  count  = var.instance_profile_name == "" ? 1 : 0
  name   = "${var.lucidum_ami_version}-${var.environment}"
  role   = aws_iam_role.lucidum[0].name
  policy = data.aws_iam_policy_document.lucidum_access_policy.json
}

data "aws_iam_policy_document" "lucidum_access_policy" {
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

  statement {
    sid = "2"
    resources = [ "*" ]
    actions = [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
    ]
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lucidum_assume_role_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ data.aws_caller_identity.current.account_id ]
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
  name               = "${var.stack_name}_${var.environment}_assume_role"
  assume_role_policy = data.aws_iam_policy_document.lucidum_assume_role_trust.json
}

resource "aws_iam_role_policy" "lucidum_assume_role_trust" {
  name   = "${var.stack_name}_${var.environment}_assume_role_policy"
  role   = aws_iam_role.lucidum_assume_role.name
  policy = data.aws_iam_policy_document.lucidum_access_policy.json
}

output "role_arn" {
  value = aws_iam_role.lucidum_assume_role.arn
}

output "lucidum_instance_private_ip" {
  value = aws_instance.lucidum.private_ip
}

output "lucidum_instance_public_ip" {
  value = aws_instance.lucidum.public_ip
}
