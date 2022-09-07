module "fw-spoke1-testvm" {
  source = "./modules/aws_vm"
  vpc_id = module.spoke1.vpc.vpc_id
  name = "fw1-spoke-testvm"
  ssh_source = ["192.168.0.0/32","192.168.0.1/32"]
  image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"
  associate_public_ip_address = true
  key_name = "tokyo"
  subnet_id = module.spoke1.vpc.public_subnets[0].subnet_id
}