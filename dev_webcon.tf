resource "proxmox_virtual_environment_vm" "webcon" {
  node_name = var.proxmox_main_node_name
  name      = "${local.env}-webcon"

  agent {
    enabled = true
  }

  machine = "q35"

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
    datastore_id = var.datastore_vm
    type         = "4m"
  }

  scsi_hardware = "virtio-scsi-pci"

  disk {
    datastore_id = var.datastore_media
    interface    = "virtio0"
    size         = 48
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

