resource "aws_vpc" "bastion_vpc" {
  cidr_block           = var.bastion_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags =  {
    Name        = "bastion-vpc"
  }
}

resource "aws_internet_gateway" "bastion_gw" {
  vpc_id = aws_vpc.bastion_vpc.id
  
  tags  = {
    Name        = "bastion-igw"
  }
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.bastion_public_subnet.id

  depends_on = [aws_internet_gateway.bastion_gw]
}