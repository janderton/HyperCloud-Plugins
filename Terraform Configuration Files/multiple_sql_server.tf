provider "azurerm" {}
variable "count"{
    default = 2
}
resource "azurerm_resource_group" "sql-group" {
  name     = "HG-SQL-RG"
  location = "east us"
  tags {
    environment = "Testing"
  }
}

resource "azurerm_sql_server" "sqlserver" {
    count = "${var.count}"
  name                         = "hgsqlserver181987-${count.index}"
  resource_group_name          = "${azurerm_resource_group.sql-group.name}"
  location                     = "${azurerm_resource_group.sql-group.location}"
  version                      = "12.0"
  administrator_login          = "hgadministrator"
  administrator_login_password = "HyperGrid123"

  tags {
    environment = "Testing"
  }
}

resource "azurerm_sql_firewall_rule" "sql-rule" {
  
  count = "${var.count}" 
  name = "hgsqlrule"
  resource_group_name = "${azurerm_resource_group.sql-group.name}"
  server_name = "${azurerm_sql_server.sqlserver.*.name[count.index]}"
  start_ip_address = "10.0.9.82"
  end_ip_address = "10.0.9.82"
  
}


output "SQL DNS NAME" {
  value = "${azurerm_sql_server.sqlserver.*.fully_qualified_domain_name}"
}
