terraform {
  required_version = "1.7.2"
  required_providers {
    proxmox = {
      source  = "registry.opentofu.org/bpg/proxmox"
      version = "0.61.1"
    }
  }
}
