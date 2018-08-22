provider "azurerm" {
}

variable "count"{
    default = 2
}
resource "azurerm_resource_group" "function-app-group" {
  name     = "HG-FUNC-RG"
  location = "east us"
  tags {
    environment = "Testing"
  }
}

resource "azurerm_storage_account" "func-app-storage" {
  name                 = "functionhgstorage"
  resource_group_name  = "${azurerm_resource_group.function-app-group.name}"
  location = "${azurerm_resource_group.function-app-group.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment = "Testing"
  }
}
output "Storage_Account" {

 value = "${azurerm_storage_account.func-app-storage.primary_connection_string}"
}

resource "azurerm_app_service_plan" "AppFunc" {
  name                = "service-app-func"
  location            = "${azurerm_resource_group.function-app-group.location}"
  resource_group_name = "${azurerm_resource_group.function-app-group.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  tags {
    environment = "Testing"
  }
  
}

resource "azurerm_function_app" "App"  {

  count = "${var.count}"
  name = "appfunc${count.index}" # Has to be all small case letters
  location = "${azurerm_resource_group.function-app-group.location}"
  resource_group_name = "${azurerm_resource_group.function-app-group.name}"
  storage_connection_string = "${azurerm_storage_account.func-app-storage.primary_connection_string}"
  app_service_plan_id = "${azurerm_app_service_plan.AppFunc.id}"
  tags {
    environment = "Testing"
  }
}
