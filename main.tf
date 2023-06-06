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
