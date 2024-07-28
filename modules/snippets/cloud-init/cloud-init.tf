resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  datastore_id = var.proxmox_datastore
  node_name    = var.proxmox_node

  source_raw {
    data = <<-EOF
    #cloud-config
    fqdn: ${var.fqdn}
    users:
      - default
      - name: ${var.username}
        groups:
          - sudo
        shell: /bin/bash
        passwd: ${var.password_hash}
        ssh_authorized_keys:
          - ${trimspace(var.ssh_public_key)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
      - apt update
      - apt install -y qemu-guest-agent
      - timedatectl set-timezone Europe/Warsaw
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "${var.fqdn}-cloud-config.yaml"
  }

}
