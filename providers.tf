terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
     
    }
    random = {
      source = "hashicorp/random"
     
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
     
    }
  }
}
  #required_version = ">=1.3.0"
  provider "azurerm" {
  features {}
  }
