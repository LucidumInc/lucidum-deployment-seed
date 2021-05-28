provider "azurerm" {
  skip_provider_registration = true
  features {}
}


locals {
  stack_name_stripped = replace(var.stack_name, "_", "0")
  tags = {
    name        = var.stack_name
    environment = var.environment
    vendor      = "lucidum"
  }
}


resource "azurerm_resource_group" "lucidum_deploy" {
  name     = var.stack_name
  location = var.microsoft_location
  tags     = local.tags
}


resource "azurerm_virtual_network" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location
  address_space       = [var.lucidum_cidr]
  tags                = local.tags
}


resource "azurerm_subnet" "lucidum_deploy" {
  name                 = var.stack_name
  resource_group_name  = azurerm_resource_group.lucidum_deploy.name
  virtual_network_name = azurerm_virtual_network.lucidum_deploy.name
  address_prefixes     = [var.lucidum_cidr]
}


resource "azurerm_public_ip" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location
  allocation_method   = "Static"
  tags                = local.tags
}


resource "azurerm_network_interface" "lucidum_deploy" {
  name                = var.stack_name
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  location            = azurerm_resource_group.lucidum_deploy.location
  tags                = local.tags

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
  network_interface_ids = [azurerm_network_interface.lucidum_deploy.id]
  custom_data           = base64encode(file("${abspath(path.root)}/../boot_scripts/boot_ubuntu18.sh"))
  tags                  = local.tags

  admin_ssh_key {
    username   = var.instance_user
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
    disk_size_gb         = var.volume_size
  }
}


resource "azurerm_network_security_group" "lucidum_deploy" {
  name                = var.stack_name
  location            = azurerm_resource_group.lucidum_deploy.location
  resource_group_name = azurerm_resource_group.lucidum_deploy.name
  tags                = local.tags

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_ssh_access"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.trusted_locations
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_ui_access"
    priority                   = 101
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.trusted_locations
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_api_access"
    priority                   = 102
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.trusted_locations
    destination_port_range     = "8000"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_airflow_access"
    description                = "${var.stack_name}_allow_airflow_access"
    priority                   = 103
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.trusted_locations
    destination_port_range     = "9080"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "${var.stack_name}_allow_mongo_access"
    description                = "${var.stack_name}_allow_mongo_access"
    priority                   = 104
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.trusted_locations
    destination_port_range     = "27017"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "lucidum_deploy" {
  network_interface_id      = azurerm_network_interface.lucidum_deploy.id
  network_security_group_id = azurerm_network_security_group.lucidum_deploy.id
}


output "lucidum_public_ip" {
  value = azurerm_public_ip.lucidum_deploy.ip_address
}
