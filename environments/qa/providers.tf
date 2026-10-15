terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name  = "b18g94"
    storage_account_name = "tfstatedisk"
    container_name       = "tfstate"
    key                  = "pps-qa-tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}
