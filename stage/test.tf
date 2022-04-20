# Virtual Machine Test for Network

# Public Subnet
resource "azurerm_public_ip" "public-vm-nic-public-ip" {
    name                            = "MSA-TEST-VM-PUBLIC-NIC-PUBLIC-IP"
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    allocation_method               = "Static"
    sku                             = "Standard"

    tags                            = var.tagging
}

resource "azurerm_network_interface" "public-vm-nic" {
    name                            = "MSA-TEST-VM-PUBLIC-NIC"
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location

    ip_configuration {
      name                          = "nic-configure"
      subnet_id                     = azurerm_subnet.public-subnet.id
      private_ip_address_allocation = "Static"
      private_ip_address            = "192.168.0.10"
      public_ip_address_id          = azurerm_public_ip.public-vm-nic-public-ip.id
    }
    tags                            = var.tagging
}

resource "azurerm_ssh_public_key" "public-test-vm-public-key" {
    name                            = "MSA-TEST-VM-PUBLIC-KEY"
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    public_key                      = file("../KP/testvm-public.pub")
}

resource "azurerm_linux_virtual_machine" "public-vm" {
    name                            = "MSA-TEST-VM-PUBLIC"  
    location                        = data.azurerm_resource_group.resource-group.location
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    size                            = "Standard_B2s"
    network_interface_ids           = [azurerm_network_interface.public-vm-nic.id]
    admin_username                  = "vmadmin"
    disable_password_authentication = true

    admin_ssh_key {
        username                    = "vmadmin"
        public_key                  = azurerm_ssh_public_key.public-test-vm-public-key.public_key
    }
    source_image_reference {
        publisher                   = "Canonical"
        offer                       = "UbuntuServer"
        sku                         = "18.04-LTS"
        version                     = "latest"
    }
    os_disk {
        name                        = "MSA-TEST-VM-PUBLIC-OS-DISK"
        caching                     = "None"
        storage_account_type        = "StandardSSD_LRS"
    }
    tags                            = var.tagging
}

# Private Subnet
resource "azurerm_network_interface" "private-vm-nic" {
    name                            = "MSA-TEST-VM-PRIVATE-NIC"
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location

    ip_configuration {
      name                          = "nic-configure"
      subnet_id                     = azurerm_subnet.private-subnet.id
      private_ip_address_allocation = "Static"
      private_ip_address            = "192.168.10.10"
    }
    tags                            = var.tagging
}

resource "azurerm_ssh_public_key" "private-test-vm-public-key" {
    name                            = "MSA-TEST-VM-PRIVATE-KEY"
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    location                        = data.azurerm_resource_group.resource-group.location
    public_key                      = file("../KP/testvm-private.pub")
}

resource "azurerm_linux_virtual_machine" "private-vm" {
    name                            = "MSA-TEST-VM-PRIVATE"  
    location                        = data.azurerm_resource_group.resource-group.location
    resource_group_name             = data.azurerm_resource_group.resource-group.name
    size                            = "Standard_B2s"
    network_interface_ids           = [azurerm_network_interface.private-vm-nic.id]
    admin_username                  = "vmadmin"
    disable_password_authentication = true

    admin_ssh_key {
        username                    = "vmadmin"
        public_key                  = azurerm_ssh_public_key.private-test-vm-public-key.public_key
    }
    source_image_reference {
        publisher                   = "Canonical"
        offer                       = "UbuntuServer"
        sku                         = "18.04-LTS"
        version                     = "latest"
    }
    os_disk {
        name                        = "MSA-TEST-VM-PRIVATE-OS-DISK"
        caching                     = "None"
        storage_account_type        = "StandardSSD_LRS"
    }
    tags                            = var.tagging
}