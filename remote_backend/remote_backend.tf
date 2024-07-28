terraform {
  required_version = "1.7.2"
  required_providers {
    azurerm = {
      source  = "registry.opentofu.org/hashicorp/azurerm"
      version = "3.112.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "backend_resource_group" {
  name     = "${var.username}-homelab-terraform-backend"
  location = "West Europe"

}

resource "azurerm_storage_account" "backend_storage_account" {
  name                     = "${var.username}0storage0account"
  resource_group_name      = azurerm_resource_group.backend_resource_group.name
  location                 = azurerm_resource_group.backend_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend_storage_container" {
  name                 = "${var.username}-homelab-storage-container"
  storage_account_name = azurerm_storage_account.backend_storage_account.name
}

