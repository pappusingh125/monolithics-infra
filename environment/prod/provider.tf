terraform {
  required_version = ">= 1.15.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "b18g94"
    storage_account_name = "tfstatedisk"
    container_name       = "tfstate"
    key                  = "mono.tfstate"
  }
}
provider "azurerm" {
  features {}
}