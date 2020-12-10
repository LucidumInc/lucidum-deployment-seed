provider "azurerm" {
  version = "=2.39.0"
  features {}
}


data "http" "local_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}


locals {
  local_public_ip = jsondecode(data.http.local_public_ip.body)
  stack_name_stripped = replace(var.stack_name, "_", "")
}


resource "azurerm_resource_group" "lucidum_deploy" {
  name     = var.stack_name
  location = var.microsoft_location
}


resource "azurerm_virtual_network" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location
  address_space       = [ var.lucidum_cidr ]
}


resource "azurerm_subnet" "lucidum_deploy" {
  name                 = var.stack_name
  resource_group_name  = azurerm_resource_group.lucidum_deploy.name
  virtual_network_name = azurerm_virtual_network.lucidum_deploy.name
  address_prefixes     = [ var.lucidum_cidr ]
}


resource "azurerm_public_ip" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}


resource "azurerm_network_interface" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location

  ip_configuration {
    name                          = var.stack_name
    subnet_id                     = azurerm_subnet.lucidum_deploy.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lucidum_deploy.id
  }
}


resource "azurerm_linux_virtual_machine" "lucidum_deploy" {
  name                  = local.stack_name_stripped
  computer_name         = local.stack_name_stripped
  resource_group_name   = azurerm_resource_group.lucidum_deploy.name
  location              = azurerm_resource_group.lucidum_deploy.location
  size                  = var.instance_size
  admin_username        = var.instance_user
  network_interface_ids = [ azurerm_network_interface.lucidum_deploy.id ]
  custom_data           = base64encode("run lucidum ansible playbook")

  admin_ssh_key {
    username = var.instance_user
    public_key = file("azure.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}


resource "azurerm_network_security_group" "lucidum_deploy" {
  name                = var.stack_name
  location            = azurerm_resource_group.lucidum_deploy.location
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_ssh_access"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    #source_address_prefix      = local.local_public_ip.ip
    destination_port_range     = "22"
    destination_address_prefix = "*"
    #destination_address_prefix = azurerm_public_ip.lucidum_deploy.ip_address
  }
}


resource "azurerm_network_interface_security_group_association" "lucidum_deployn" {
  network_interface_id      = azurerm_network_interface.lucidum_deploy.id
  network_security_group_id = azurerm_network_security_group.lucidum_deploy.id
}


output "lucidum_public_ip" {
  value = azurerm_public_ip.lucidum_deploy.ip_address
}


output "local_public_ip" {
  value = local.local_public_ip.ip
}
