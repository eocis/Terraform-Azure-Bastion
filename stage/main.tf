# Define Provider
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.2.0"
        }
    }
}

provider "azurerm" {
    features {}
}


### Define & Creation ###

# Define Resource Group
resource "azurerm_resource_group" "resource-group" {
    count                           = data.azurerm_resource_group.resource-group.name == var.resource-group-name ? 0 : 1
    name                            = var.resource-group-name
    location                        = var.azure-location
}

# Create vnet(Virtual Network)
resource "azurerm_virtual_network" "vnet" {
    name                            = var.vnet-name
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    address_space                   = [var.vnet-cidr]
    tags                            = var.tagging
}

resource "azurerm_subnet" "public-subnet" {
    name                            = var.public-subnet-name
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    virtual_network_name            = azurerm_virtual_network.vnet.name
    address_prefixes                = [var.subnet-cidrs["public"]]
}

resource "azurerm_subnet" "private-subnet" {
    name                            = var.private-subnet-name
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    virtual_network_name            = azurerm_virtual_network.vnet.name
    address_prefixes                = [var.subnet-cidrs["private"]]
}

resource "azurerm_public_ip" "nat-gw-public-ip" {
    name                            = var.public-nat-ip-name
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    allocation_method               = var.nat-gateway-allocation-method
    sku                             = var.nat-gateway-public-sku
    tags                            = var.tagging
}

resource "azurerm_nat_gateway" "nat-gw" {
    name                            = var.public-nat-name
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    tags                            = var.tagging
}


### Association ###

# NAT - Subnet
resource "azurerm_subnet_nat_gateway_association" "public-nat-association" {
    subnet_id                       = azurerm_subnet.private-subnet.id
    nat_gateway_id                  = azurerm_nat_gateway.nat-gw.id
}

# NAT - Public IP
resource "azurerm_nat_gateway_public_ip_association" "nat-public-ip-association" {
    nat_gateway_id                  = azurerm_nat_gateway.nat-gw.id
    public_ip_address_id            = azurerm_public_ip.nat-gw-public-ip.id
}

# Subnet - Security Group
resource "azurerm_subnet_network_security_group_association" "public-security-group-association" {
    subnet_id                       = azurerm_subnet.public-subnet.id
    network_security_group_id       = azurerm_network_security_group.public-subnet-security-group.id
}