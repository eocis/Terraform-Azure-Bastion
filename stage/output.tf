output "check-resource-group" {
    value = data.azurerm_resource_group.resource-group.name == var.resource-group-name ? format("%s was Exist", var.resource-group-name) : format("%s was Not Exist", var.resource-group-name)
}

output "nat-gateway-public-ip" {
    value = azurerm_public_ip.nat-gw-public-ip.ip_address
}

output "public-test-vm-public-ip" {
    value = azurerm_public_ip.public-vm-nic-public-ip.ip_address
}