resource "azurerm_network_interface" "nic" {
  depends_on = [azurerm_virtual_network.vnet  ]
  location                       = "swedencentral"
  name                           = "nic-vm-001"
  resource_group_name            = var.resourceGroupName
  ip_configuration {
    name                                               = "internal"
    private_ip_address_allocation                      = "Dynamic"
    subnet_id                                          = azurerm_subnet.web.id
  }
}

data "azurerm_key_vault" "kv" {
  depends_on = [azurerm_key_vault.kv  ]
  name                = var.key_vault_name
  resource_group_name = var.resourceGroupName
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"   
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_linux_virtual_machine" "virtualmachine" {
  depends_on = [azurerm_virtual_network.vnet  ]
  admin_password                     = data.azurerm_key_vault_secret.vm_password.value
  admin_username                     = "adminuser"
  computer_name                      = "vm-001"
  location                           = var.location
  name                               = "vm-001"
  network_interface_ids              = [azurerm_network_interface.nic.id]
  resource_group_name                = var.resourceGroupName
  size                               = "Standard_D2as_v5"
  zone                               = "3"
  disable_password_authentication    = false
  os_disk {
    caching                          = "ReadWrite"
    storage_account_type             = "Premium_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(file("${path.module}/scripts/vm_nginx.sh"))
}

resource "azurerm_network_interface" "nic2" {
  depends_on = [azurerm_virtual_network.vnet  ]
  name                = "nic-vm-002"
  location            = var.location
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "virtualmachine2" {
  name                = "vm-002"
  computer_name       = "vm-002"
  location            = var.location
  resource_group_name = var.resourceGroupName
  size                = "Standard_D2as_v5"

  admin_username                  = "adminuser"
  admin_password                  = data.azurerm_key_vault_secret.vm_password.value
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  custom_data = base64encode(file("${path.module}/scripts/vm_nginx.sh"))

}