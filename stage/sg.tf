resource "azurerm_network_security_group" "public-subnet-security-group" {
    name                            = var.public-subnet-sg-name
    location                        = data.azurerm_resource_group.resource-group.location
    resource_group_name             = data.azurerm_resource_group.resource-group.name

    security_rule = [ {
      access                                        = "Allow"
      description                                   = "Allow SSH Inbound"
      destination_address_prefix                    = "*"
      destination_address_prefixes                  = null
      destination_application_security_group_ids    = null
      destination_port_range                        = "22"
      destination_port_ranges                       = null
      direction                                     = "Inbound"
      name                                          = "Allow SSH"
      priority                                      = 100
      protocol                                      = "*"
      source_address_prefix                         = "*"
      source_address_prefixes                       = null
      source_application_security_group_ids         = null
      source_port_range                             = "*"
      source_port_ranges                            = null
    }]
    tags                                            = var.tagging
}