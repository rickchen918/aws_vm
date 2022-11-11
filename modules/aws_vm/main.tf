#data "aws_region" "current" {}

resource "aws_security_group" "default" {
  name = var.name
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0 
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0 
    to_port = 0 
    protocol = -1
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_security_group_rule" "ssh" {
  count = var.associate_public_ip_address ? 1 : null
  type = "ingress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = var.ssh_source
  security_group_id = aws_security_group.default.id
}

data "aws_ami" "amzlinux" {
    # owners = ["${var.owner}"]
    filter {
      name = "name"
      values = ["${var.image_name}"]
    }
}

resource "aws_instance" "default" {
  ami = data.aws_ami.amzlinux.id
  instance_type = var.instance_type
  subnet_id =  var.subnet_id
  key_name = var.key_name
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  tags = var.tags
}