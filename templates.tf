data "proxmox_virtual_environment_vm" "windows_server_2022_template" {
  node_name = var.proxmox_main_node_name
  vm_id     = 9001
}


