data "local_file" "ssh_public_key" {
  filename = "./key.pub"
}

locals {
  hostname   = "freyr"
  freyr_fqdn = "${local.env}-${local.hostname}.${var.lab_domain}"
}

module "freyr_cloud_init" {
  source            = "./modules/snippets/cloud-init"
  ssh_public_key    = data.local_file.ssh_public_key.content
  fqdn              = local.freyr_fqdn
  username          = var.proxmox_username
  proxmox_node      = var.proxmox_main_node_name
  proxmox_datastore = var.datastore_media
  password_hash     = var.proxmox_password_hash
}

resource "proxmox_virtual_environment_vm" "freyr" {
  name      = "${local.env}-freyr"
  node_name = var.proxmox_main_node_name

  reboot = true

  agent {
    enabled = true
  }

  cpu {
    type  = "host"
    cores = 16
  }

  memory {
    dedicated = 16384
  }

  serial_device {
    device = "socket"
  }

  disk {
    datastore_id = var.datastore_vm
    interface    = "virtio0"
    file_id      = proxmox_virtual_environment_download_file.debian_12.id
    iothread     = true
    discard      = "on"
    size         = 64
  }

  initialization {
    datastore_id = var.datastore_vm
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = module.freyr_cloud_init.file_id
  }

  network_device {
    bridge  = var.bridge_default
    vlan_id = proxmox_virtual_environment_network_linux_vlan.vlan_dmz.vlan
  }
}

resource "ansible_host" "freyr" {
  name = local.freyr_fqdn
}


resource "time_sleep" "freyr_wait_before_ansible" {
  depends_on = [proxmox_virtual_environment_vm.freyr]

  create_duration = "30s"
}

resource "ansible_playbook" "freyr_podman" {
  playbook   = "./playbooks/install-podman.yml"
  name       = local.freyr_fqdn
  depends_on = [time_sleep.freyr_wait_before_ansible]
  replayable = false
}

resource "ansible_playbook" "freyr_dotfiles" {
  playbook   = "./playbooks/install-dotfiles.yml"
  name       = local.freyr_fqdn
  depends_on = [ansible_playbook.freyr_podman]
  replayable = false
}
