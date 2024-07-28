terraform {
  required_version = "1.7.2"
  required_providers {
    proxmox = {
      source  = "registry.opentofu.org/bpg/proxmox"
      version = "0.61.1"
    }
    ansible = {
      source  = "registry.opentofu.org/ansible/ansible"
      version = "1.3.0"
    }
    local = {
      source  = "registry.opentofu.org/hashicorp/local"
      version = "2.5.1"
    }
    null = {
      source  = "registry.opentofu.org/hashicorp/null"
      version = "3.2.2"
    }
    time = {
      source  = "registry.opentofu.org/hashicorp/time"
      version = "0.11.2"
    }
    azurerm = {
      source  = "registry.opentofu.org/hashicorp/azurerm"
      version = "3.112.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "lumenn-homelab-terraform-backend"
    storage_account_name = "lumenn0storage0account"
    container_name       = "lumenn-homelab-storage-container"
    key                  = "tfstate"
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "terraform"
  }

}
