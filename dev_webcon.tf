resource "proxmox_virtual_environment_vm" "webcon" {
  node_name = var.proxmox_main_node_name
  name      = "${local.env}-webcon"

  agent {
    enabled = true
  }

  machine = "pc-q35-8.1"

  operating_system {
    type = "win11"
  }

  clone {
    vm_id        = data.proxmox_virtual_environment_vm.windows_server_2022_template.vm_id
    node_name    = var.proxmox_main_node_name
    datastore_id = var.datastore_media

  }

  tpm_state {
    datastore_id = var.datastore_vm
    version      = "v2.0"
  }

  efi_disk {
    datastore_id      = var.datastore_vm
    type              = "4m"
    pre_enrolled_keys = true
  }

  scsi_hardware = "virtio-scsi-pci"

  disk {
    datastore_id = var.datastore_media
    interface    = "virtio0"
    size         = 48
    iothread     = true
  }

  vga {
    memory = 16
    type   = "std"
  }

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 8 * 1024
  }

  network_device {
    bridge  = var.bridge_default
    vlan_id = proxmox_virtual_environment_network_linux_vlan.vlan_dmz.vlan
  }


  bios = "ovmf"

}

locals {
  webcon_linux = "${local.env}-webcon-linux.${var.lab_domain}"
}

module "webcon_linux_cloud_init" {
  source            = "./modules/snippets/cloud-init"
  ssh_public_key    = data.local_file.ssh_public_key.content
  fqdn              = local.webcon_linux
  username          = var.proxmox_username
  proxmox_node      = var.proxmox_main_node_name
  proxmox_datastore = var.datastore_media
  password_hash     = var.proxmox_password_hash
}

resource "proxmox_virtual_environment_vm" "webcon_linux" {
  name      = "${local.env}-webcon-linux"
  node_name = var.proxmox_main_node_name

  reboot = true

  agent {
    enabled = true
  }

  cpu {
    type  = "host"
    cores = 8
  }

  memory {
    dedicated = 8 * 1024
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

    user_data_file_id = module.webcon_linux_cloud_init.file_id
  }

  network_device {
    bridge  = var.bridge_default
    vlan_id = proxmox_virtual_environment_network_linux_vlan.vlan_dmz.vlan
  }
}

resource "ansible_host" "webcon_linux" {
  name = local.webcon_linux
}


resource "time_sleep" "webcon_linux_wait_before_ansible" {
  depends_on = [proxmox_virtual_environment_vm.webcon_linux]

  create_duration = "30s"
}

resource "ansible_playbook" "webcon_linux_podman" {
  playbook   = "./playbooks/install-podman.yml"
  name       = local.webcon_linux
  depends_on = [time_sleep.webcon_linux_wait_before_ansible]
  replayable = false
}

resource "ansible_playbook" "webcon_linux_dotfiles" {
  playbook   = "./playbooks/install-dotfiles.yml"
  name       = local.webcon_linux
  depends_on = [ansible_playbook.webcon_linux_podman]
  replayable = false
}
