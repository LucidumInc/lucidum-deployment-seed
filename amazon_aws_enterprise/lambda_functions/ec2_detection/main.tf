variable "ec2_detection" {}
variable "environment" {}
variable "stack_prefix" {}
variable "lambda_log_group_prefix" {}
variable "execution_role_arn" {}

locals {
  ec2_detect_prefix  = "lucidum-ec2-detection-${var.environment}"
}

resource "aws_cloudwatch_event_rule" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  name        = var.stack_prefix
  description = var.stack_prefix

  event_pattern = <<EOF
{
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "source": [
    "aws.ec2"
  ],
  "detail": {
    "state": [
      "running",
      "terminated",
      "stopped"
    ]
  }
}
EOF
}

resource "aws_lambda_function" "ec2_detection" {
  count            = var.ec2_detection ? 1 : 0
  filename         = "ec2_detection.zip"
  function_name    = "ec2_detection"
  role             = var.execution_role_arn
  handler          = "exports.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.ec2_detection[0].output_path)

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [
    #aws_iam_role_policy_attachment.ec2_detection[0],
    aws_cloudwatch_log_group.ec2_detection[0],
  ]
}

resource "aws_cloudwatch_log_group" "ec2_detection" {
  count             = var.ec2_detection ? 1 : 0
  name_prefix       = "${var.lambda_log_group_prefix}/${var.stack_prefix}"
  retention_in_days = 14
}

resource "aws_s3_bucket" "ec2_detection" {
  count         = var.ec2_detection ? 1 : 0
  bucket_prefix = "${var.stack_prefix}-"
  acl           = "private"

  tags = {
    Name        = var.stack_prefix
    Environment = var.environment
  }
}

data "archive_file" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  type        = "zip"
  source_file = "lambda_functions/ec2_detection/ec2_detection.py"
  output_path = "ec2_detection.zip"
}
