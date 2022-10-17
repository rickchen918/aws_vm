variable "resource_group_name" {
  type = string 
  description = "resouce group name"
}

variable "location" {
  type = string 
  description = "deployment region"
}

variable "subnet_id" {
  type = string
  description = "subnet for interface placement"
}

variable "name" {
  type = string
  description = "resource naming"
}

variable "vm_size" {
  type = string 
  default = "Standard_B1ms"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "publisher" {
  type = string
  default = "Canonical"
  description = "info for source image"
}

variable "offer" {
  type = string
  default = "UbuntuServer"
  description = "info for source image"
}

variable "sku" {
  type = string
  default = "16.04-LTS"
  description = "info for source image"
}

variable "ver" {
  type = string
  default = "latest"
  description = "info for source image"
}

variable "ssh_source" {
  type = list
  description = "source is allowed for ssh"
}

variable "public_ip" {
  type = bool
  default = true
  description = "allocate public ip "
}
