variable "stack_name" {
  type    = string
  default = "lucidum_assume_role"
}

variable "trust_account" {
  type    = string
  default = "906036546615"
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
