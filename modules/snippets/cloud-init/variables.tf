variable "proxmox_datastore" {
  description = "Datastore on which snippet will be created."
  type        = string
}

variable "proxmox_node" {
  description = "Name of one on which snippet will be stored."
  type        = string
}

variable "fqdn" {
  description = "Fully qualified domain name, which will be set in hosts file."
  type        = string
}

variable "username" {
  description = "Username which will be used to create a user."
  type        = string

}

variable "ssh_public_key" {
  description = "Content of ssh public key which will be used to configure ssh connections."
  type        = string
}

variable "password_hash" {
  description = "This is a password that will be available for a user, although remote password login is off."
  type        = string
}
