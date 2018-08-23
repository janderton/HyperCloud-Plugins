provider "azurerm" {
}


resource "azurerm_resource_group" "vpc-group" {
  name     = "HG-VPC-RG"
  location = "east us"
}



 resource "azurerm_virtual_network" "network" {
  name                = "dev-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.vpc-group.location}"
  resource_group_name = "${azurerm_resource_group.vpc-group.name}"
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }
}
