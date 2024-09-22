locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}

variable "cloudflare_api_token" {
  description = "Token allowing access to cloudflare."
  type        = string
}

variable "cloudflare_personal_zone" {
  description = "Zone under which DNS records will be modified."
  type        = string
}

variable "public_ipv4" {
  description = "Public IPv4 address."
  type        = string
}

variable "public_ipv6" {
  description = "Public IPv4 address."
  type        = string
}

variable "public_domain" {
  description = "Public domain name."
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token accordint to this schema username@realm!provider=xxxx-xxx-xxx-xxx"
  type        = string
}

variable "proxmox_endpoint" {
  description = "Full https link like https://proxmox.com:8006 with port address."
  type        = string
}

variable "proxmox_main_node_name" {
  description = "Name of main proxmox node."
  type        = string
}

variable "proxmox_username" {
  description = "Username for default user used across vm's.'"
  type        = string
}

variable "proxmox_password_hash" {
  description = "Password for default user used across vm's.'"
  type        = string
}

variable "lab_domain" {
  description = "This is domain used for the lab like internal.example.com"
  type        = string
}

variable "vlan_dmz" {
  type = number
}

variable "vlan_internal" {
  type = number
}

variable "bridge_default" {
  type    = string
  default = "vmbr0"
}

variable "datastore_media" {
  description = "Name of datastore used for keeping snippets and images."
  type        = string
  default     = "media"
}

variable "datastore_vm" {
  description = "Name of datastore used to keep disks of vm's."
  type        = string
  default     = "local-zfs"
}


