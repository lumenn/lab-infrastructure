resource "proxmox_virtual_environment_network_linux_vlan" "vlan_dmz" {
  node_name = var.proxmox_main_node_name
  name      = "${local.env}_${var.bridge_default}_${var.vlan_dmz}"

  interface = var.bridge_default
  vlan      = var.vlan_dmz
  address   = "172.16.40.1/21"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan_internal" {
  node_name = var.proxmox_main_node_name
  name      = "${local.env}_${var.bridge_default}_${var.vlan_internal}"

  interface = var.bridge_default
  vlan      = var.vlan_internal
  address   = "172.16.72.1/21"
}
