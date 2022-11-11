variable "owner" {
    type = string
    default = null
}

variable "image_name" {
  type = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
  default = true
}

# variable "vpc_security_group_ids" {
#   type = string
# }

variable "name" {
  type = string
  default = null
}

variable "vpc_id" {
  type = string
}

variable "ssh_source" {
  type = list
  default = null
}

variable "tags" {
  type = map(string)
  default = {}
}