resource "proxmox_virtual_environment_download_file" "debian_12" {
  content_type = "iso"
  datastore_id = var.datastore_media
  node_name    = var.proxmox_main_node_name
  url          = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"

  file_name = "${local.env}lab-debian-12-amd64_qcow2.img"
  overwrite = false
}

resource "proxmox_virtual_environment_download_file" "windows_server_2022_eval" {
  content_type = "iso"
  datastore_id = var.datastore_media
  node_name    = var.proxmox_main_node_name
  url          = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
  file_name    = "${local.env}_windows_server_2022.iso"
  overwrite    = false
}

resource "proxmox_virtual_environment_download_file" "virtio_drivers" {
  content_type        = "iso"
  datastore_id        = var.datastore_media
  node_name           = var.proxmox_main_node_name
  url                 = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
  file_name           = "virtio-win.iso"
  overwrite           = false
  overwrite_unmanaged = true
}
