variable "stack_name" {
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
