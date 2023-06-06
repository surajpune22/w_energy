resource "azurerm_virtual_network" "myvnet" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = var.rgname
  address_space       = var.vnetaddr

  tags = {
    environment = "Dev"
    Application = "Test_App"
    CreatedBy   = "terraform"
  }
}
resource "azurerm_subnet" "mysub" {
  name                 = var.sub1name
  resource_group_name  = var.rgname
  virtual_network_name = var.vnetname
  address_prefixes     = var.sub1addr
  depends_on = [
    azurerm_virtual_network.myvnet
  ]
}

resource "azurerm_network_interface" "mynic" {
  name                = "nic1"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "pip-1"
    subnet_id                     = var.subnet1_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypub.id
  }
  depends_on = [
    azurerm_subnet.mysub, 
    azurerm_virtual_network.myvnet,
    azurerm_public_ip.mypub
  ]
}

resource "azurerm_public_ip" "mypub" {
  name                = "public_ip_1"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Integ"
  }
  depends_on = [
    azurerm_subnet.mysub, 
    azurerm_virtual_network.myvnet,
  ]
}