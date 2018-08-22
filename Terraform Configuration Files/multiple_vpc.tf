provider "azurerm" {}

variable "addresses" {
  default = ["10.1.0.0/24", "10.2.0.0/24"]
}

variable "count" {
  default = 2
}


resource "azurerm_resource_group" "vpc-group" {
  name     = "HG-VPC-RG"
  location = "east us"
}

resource "azurerm_virtual_network" "network" {
  count               = "${var.count}"
  name                = "dev-network-${count.index}"
  address_space       = ["${var.addresses[count.index]}"]
  location            = "${azurerm_resource_group.vpc-group.location}"
  resource_group_name = "${azurerm_resource_group.vpc-group.name}"
}
