variable "microsoft_location" {
  type    = string
  default = "West US"
}


variable "stack_name" {
  type    = string
  default = "lucidum_azure_deployment"
}


variable "environment" {
  type    = string
  default = "Production"
}


variable "lucidum_cidr" {
  type    = string
  default = "10.99.99.0/24"
}


variable "instance_user" {
  type    = string
  default = "ubuntu"
}


variable "instance_size" {
  type    = string
  #default = "Standard_D32d_v4"
  default = "Standard_F2"
}
