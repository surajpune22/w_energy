variable "rgname" {
    type = string
    description = "resource group name" 
}

variable "location" {
    type = string
    default = "West Europe"
}

variable "vnetname" {
    type = string
    description = "Vnet name for RC OMS"
}

variable "vnetaddr" {
    type = list(string)
    description = "Vnet ranges define"
}

variable "sub1name" {
    type = string
    description = "subnet1 Name"  
}

variable "sub1addr" {
    type = list(string)
    description = "subnet1 Range" 
}
