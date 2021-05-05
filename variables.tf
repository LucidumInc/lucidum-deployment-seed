# required variables

variable "environment" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "source_ami_account_number" {
  type = string
}

variable "instance_size" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type    = string
  default = ""
}

variable "trusted_cidrs" {
  type    = list(any)
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

variable "playbook_version" {
  type = string
}

variable "playbook_edition" {
  type = string
}


# optional overrides

variable "tags" {
  type    = map
  default = {Vendor="Lucidum"}
}

variable "volume_size" {
  type    = number
  default = 1000
}

variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "security_group_id" {
  type    = string
  default = ""
}

variable "instance_profile_name" {
  type    = string
  default = ""
}

variable "backup_ebs_volume_id" {
  type    = string
  default = ""
}

variable "data_ebs_volume" {
  type    = bool
  default = false
}

variable "lucidum_ami_id" {
  type    = string
  default = ""
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "kinesis_table" {
  type    = bool
  default = false
}

variable "lambda_log_group_prefix" {
  type    = string
  default = "/aws/lambda/"
}

variable "ec2_detection" {
  type    = bool
  default = false
}


# assume role vars

variable "stack_name" {
  type    = string
  default = "lucidum_assume_role"
}

variable "trust_external_id" {
  type    = string
  default = "lucidum-access"
}
