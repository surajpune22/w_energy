terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_id       = "7ddee52c-9985-4cdd-8bc0-e9b83b2db771"
  client_secret   = "I2x8Q~EGsAHZs8.QzTopZKx13Sgb5dannAQNqbbk"
  subscription_id = "12b6c156-e77f-454a-994e-5537a2eaaa45"
  tenant_id       = "ab67350a-ec6b-49d8-bab0-b9590062f9b9"

}
resource "azurerm_resource_group" "myrg" {
  name = var.rgname
  location = var.location
}

module "network" {
    source = "./modules/network"
    rgname = var.rgname
    location = var.location
    vnetname = var.vnetname
    vnetaddr = var.vnetaddr
    sub1name = var.sub1name
    sub1addr = var.sub1addr
    subnet1_id = module.network.snet_id
    depends_on = [ 
        azurerm_resource_group.myrg
     ]
}

module "vm" {
    source = "./modules/vm"
    nic_id = module.network.mynic_id
    rgname = var.rgname
    location = var.location
    depends_on = [
      azurerm_resource_group.myrg,
      module.network
    ]
}

module "db" {
  source = "./modules/db"
  rgname = var.rgname
  location = var.location
  depends_on = [
    azurerm_resource_group.myrg,
      module.network
  ]
}