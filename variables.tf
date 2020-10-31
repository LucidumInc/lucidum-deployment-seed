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

variable "lucidum_ami_version" {
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
  type = string
}

variable "trusted_cidrs" {
  type = list
}

variable "boot_edition" {
  type    = string
}

# optional overrides

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
  type   = string
  string = "us-east-1"
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
