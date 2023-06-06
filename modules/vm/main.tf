resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "vm1"
  resource_group_name = var.rgname
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "manage"
  network_interface_ids = [
    var.nic_id,
  ]

  admin_ssh_key {
    username   = "manage"
    public_key = file("./my_id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202209200"
  }
  tags = {
    created_by  = "Terraform_Pune_DevOps"
    environment = "Dev"
  }
}
resource "azurerm_managed_disk" "mydisk" {
  name                 = "disk1"
  location             = var.location
  resource_group_name  = var.rgname
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"

  tags = {
    environment = "Dev"
  }
}
resource "azurerm_virtual_machine_data_disk_attachment" "mount_disk1" {
  managed_disk_id    = azurerm_managed_disk.mydisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.myvm.id
  lun                = "0"
  caching            = "ReadWrite"
}

resource "azurerm_network_security_group" "mynsg" {
  name                = "nsg1"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "managedOpenVPN"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "20.16.113.10/32"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_interface_security_group_association" "myasso" {
  network_interface_id      = var.nic_id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}
