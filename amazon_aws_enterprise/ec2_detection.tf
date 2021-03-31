locals {
  ec2_detect_prefix  = "lucidum-ec2-detection-${var.environment}"
}

resource "aws_cloudwatch_event_rule" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  name        = local.ec2_detect_prefix
  description = local.ec2_detect_prefix

  event_pattern = <<EOF
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
EOF
}

resource "aws_iam_role" "ec2_detection" {
  count = var.ec2_detection ? 1 : 0
  name  = local.ec2_detect_prefix

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


resource "aws_lambda_function" "ec2_detection" {
  count            = var.ec2_detection ? 1 : 0
  filename         = "lambda_functions/ec2_detection.zip"
  function_name    = "ec2_detection"
  role             = aws_iam_role.ec2_detection[0].arn
  handler          = "exports.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.ec2_detection[0].output_path)

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.ec2_detection[0],
    aws_cloudwatch_log_group.ec2_detection[0],
  ]
}

resource "aws_cloudwatch_log_group" "ec2_detection" {
  count             = var.ec2_detection ? 1 : 0
  name              = "${var.lambda_log_group_prefix}/${local.ec2_detect_prefix}"
  retention_in_days = 14
}

resource "aws_s3_bucket" "ec2_detection" {
  count         = var.ec2_detection ? 1 : 0
  bucket_prefix = "${local.ec2_detect_prefix}-"
  acl           = "private"

  tags = {
    Name        = local.ec2_detect_prefix
    Environment = var.environment
  }
}

data "archive_file" "ec2_detection" {
  count       = var.ec2_detection ? 1 : 0
  type        = "zip"
  source_file = "lambda_functions/ec2_detection.py"
  output_path = "lambda_functions/ec2_detection.zip"
}
