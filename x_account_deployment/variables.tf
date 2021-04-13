variable "stack_name" {
  type    = string
  default = "lucidum_x_account_deployment"
}

variable "assume_role_name" {
  type    = string
  default = "lucidum_assume_role"
}

variable "trust_account" {
  type    = string
}

variable "trust_external_id" {
  type    = string
  default = "lucidum-access"
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "max_session_duration" {
  type    = number
  default = 43200
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "ec2_detection" {
  type    = bool
  default = false
}

variable "lambda_log_group_prefix" {
  type    = string
  default = "/aws/lambda/"
}

variable "lucidum_s3_bucket" {
  type    = string
}
