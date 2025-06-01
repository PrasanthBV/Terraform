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
  subscription_id  = "1729be0f-c009-4d17-9cf2-817a3aa9eabf"
  client_id        = "40e77ae6-6ee9-490b-9fbf-204316f36330"
  client_secret    = "l-W8Q~nkWCUjnXGP6pgGuvqXHMMpc6yJsg7d7agD"
  tenant_id        = "86aaec34-9e60-4a0b-89fb-090103cf11f0"
}

resource "azurerm_resource_group" "rg1" {
  name     = "Sampletest"
  location = "East US"
}


resource "azurerm_virtual_network" "vnet1" {
  name                = "sampletestVnet1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "SampletestSubnet1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"] 
}