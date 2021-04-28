variable "environment" {}
variable "stack_prefix" {}
variable "lambda_log_group_prefix" {}
variable "execution_role_arn" {}
variable "s3_bucket" {}


resource "aws_cloudwatch_event_rule" "ec2_detection" {
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
  filename         = "ec2_detection.zip"
  function_name    = "lucidum_ec2_detection"
  role             = var.execution_role_arn
  handler          = "ec2_detection.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.ec2_detection.output_path)

  runtime = "python3.8"

  environment {
    variables = {
      s3_bucket = var.s3_bucket
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.ec2_detection,
  ]
}

resource "aws_cloudwatch_log_group" "ec2_detection" {
  name_prefix       = "${var.lambda_log_group_prefix}${var.stack_prefix}-"
  retention_in_days = 14
}

data "archive_file" "ec2_detection" {
  type        = "zip"
  source_file = "${path.module}/ec2_detection.py"
  output_path = "ec2_detection.zip"
}

resource "aws_cloudwatch_event_target" "event_rule_target_with_lambda" {
  rule = aws_cloudwatch_event_rule.ec2_detection.name
  target_id = "ec2_detection"
  arn = aws_lambda_function.ec2_detection.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ec2_detection" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_detection.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.ec2_detection.arn
}
