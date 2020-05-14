provider "aws" {
  region = "ap-south-1"
}

module "bastion_network" {
  source = "../bastion/network"

  bastion_cidr         = "10.0.0.0/16"
  bastion_private_cidr = "10.0.2.0/24"
  bastion_public_cidr  = "10.0.1.0/24"
  available_zone       = "ap-south-1a"
}

resource "aws_instance" "vm" {
  ami                         = "ami-0b44050b2d893d5f7"
  instance_type               = "t2.micro"
  subnet_id                   = module.bastion_network.bastion_public_subnet_id
  vpc_security_group_ids      = [module.bastion_network.bastion_sg_id, module.bastion_network.bastion_private_sg_id]
  key_name                    = "deployer-key1"
  associate_public_ip_address = true

  tags = {
    Name = "BastionVM"
  }
}


module "terraform-mongodb" {
  source                      = "../"
  instance_type               = "t2.micro"
  ami                         = "ami-025a6980e480783c1"
  subnet_id                   = module.bastion_network.bastion_private_subnet_id
  vpc_security_group_ids      = [module.bastion_network.bastion_private_sg_id]
  associate_public_ip_address = false
  key_name                    = "deployer-key1"
  tags = {
    Name = "Packer mongo example"
  }

}
