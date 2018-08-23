provider "azurerm" {}

variable "count"{
    default = 2
}

resource "azurerm_resource_group" "compute-group" {
  name     = "HG-COMPUTE-RG"
  location = "east us"
  tags {
    environment = "testing"
  }
}

resource "azurerm_virtual_network" "vm-network" {
  name                = "management-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.compute-group.location}"
  resource_group_name = "${azurerm_resource_group.compute-group.name}"
  tags {
    environment = "testing"
  }
}

resource "azurerm_subnet" "internal-subnet" {
  name                 = "management-subnet"
  resource_group_name  = "${azurerm_resource_group.compute-group.name}"
  virtual_network_name = "${azurerm_virtual_network.vm-network.name}"
  address_prefix       = "10.0.2.0/24"
  tags {
    environment = "testing"
  }
}

resource "azurerm_public_ip" "external" {
  
  count = "${var.count}"
  name                         = "ubuntu-public${count.index}"
  resource_group_name          = "${azurerm_resource_group.compute-group.name}"
  location                     = "${azurerm_resource_group.compute-group.location}"
  public_ip_address_allocation = "Dynamic"
  tags {
    environment = "testing"
  }
}

resource "azurerm_network_interface" "ubuntu-interface" {
  
  count = "${var.count}"
  name                = "ubuntu-nic${count.index}"
  location            = "${azurerm_resource_group.compute-group.location}"
  resource_group_name = "${azurerm_resource_group.compute-group.name}"

  ip_configuration {
    name                          = "configuration${count.index}"
    subnet_id                     = "${azurerm_subnet.internal-subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.external.*.id[count.index]}"
  }

  tags {
    environment = "testing"
  }
}

resource "azurerm_virtual_machine" "ubuntu" {
  
  count = "${var.count}"
  name                  = "ubuntu-vm${count.index}"
  location              = "${azurerm_resource_group.compute-group.location}"
  resource_group_name   = "${azurerm_resource_group.compute-group.name}"
  network_interface_ids = ["${azurerm_network_interface.ubuntu-interface.*.id[count.index]}"]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "ubuntuvmosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hg-ubuntu${count.index}"
    admin_username = "hgadmin"
    admin_password = "HyperGrid123"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "testing"
  }
}
