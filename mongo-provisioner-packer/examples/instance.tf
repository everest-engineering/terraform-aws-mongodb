module "terraform-mongodb" {
  source = "../"
  instance_type = "t2.micro"
  ami = "ami-0f157b14eb16e6769"
  subnet_id = aws_subnet.main-subnet-public-1.id
  vpc_security_group_ids=[aws_security_group.sg_mongodb.id]
  key_name="deployer-key1"
  platform="ubuntu-18.04"
  mongodb_version="4.2"
  ami_version="1.0"
  tags = {
    Name = "Packer mongo example"
  }
}

output "mongo_connect_url" {
  value = module.terraform-mongodb.mongo_connect_url
}

