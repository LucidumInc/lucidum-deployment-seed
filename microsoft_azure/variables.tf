variable "microsoft_location" {
  type = string
}

variable "environment" {
  type = string
}

variable "lucidum_cidr" {
  type = string
}

variable "instance_size" {
  type = string
}

variable "trusted_locations" {
  type = list(any)
}

variable "stack_name" {
  type    = string
  default = "lucidum_azure_deployment"
}

variable "instance_user" {
  type    = string
  default = "ubuntu"
}
