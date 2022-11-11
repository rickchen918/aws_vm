# aws vm example
module "fw-spoke1-testvm" {
  source = "./modules/aws_vm"
  vpc_id = module.spoke1.vpc.vpc_id
  name = "fw1-spoke-testvm"
  ssh_source = ["192.168.0.0/32","192.168.0.1/32"]
  image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"
  associate_public_ip_address = true
  key_name = "tokyo"
  subnet_id = module.spoke1.vpc.public_subnets[0].subnet_id
  tags = {
    APP = "spk2",
    Name = "spke2"
  }
}


# azure vm example
module "az-test-spoke1-vm" {
    source = "./modules/azure_vm"
    resource_group_name = module.az-test-spoke1.vnet.resource_group
    location = module.az-test-spoke1.vnet.region
    subnet_id = module.az-test-spoke1.vnet.public_subnets[0].subnet_id
    name = "az-test-spoke1-vm"
    admin_username = "ubuntu"
    admin_password = "Aviatrix123#"
    ssh_source = ["10.0.0.0/8","220.132.86.183/32"]
    public_ip = true
    tags = {
      APP = "spk2",
      Name = "spke2"
    }
}
