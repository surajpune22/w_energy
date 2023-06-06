output "mynic_id" {
  value = azurerm_network_interface.mynic.id
}

output "snet_id" {
   value = azurerm_subnet.mysub.id
}