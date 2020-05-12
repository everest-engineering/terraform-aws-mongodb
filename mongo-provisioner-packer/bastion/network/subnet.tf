resource "aws_subnet" "bastion_private_subnet" {
  cidr_block        = var.bastion_private_cidr
  availability_zone = var.available_zone
  vpc_id            = aws_vpc.bastion_vpc.id

  tags = {
    Name        = "bastion-private-subnet"
  }
}

resource "aws_subnet" "bastion_public_subnet" {
  cidr_block        = var.bastion_public_cidr
  availability_zone = var.available_zone
  vpc_id            = aws_vpc.bastion_vpc.id

  tags = {
   Name        = "bastion-public-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.bastion_vpc.id

  tags = {
    Name        = "bastion-public-route-table"
  }
}

resource "aws_route_table_association" "associate_public_subnet" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.bastion_public_subnet.id
}

resource "aws_route" "route_to_internet" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bastion_gw.id
  route_table_id         = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.bastion_vpc.id

  tags = {
    
    Name        = "bastion-private-route-table"
  }
}
resource "aws_route_table_association" "associate_private_subnet" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.bastion_private_subnet.id
}

resource "aws_route" "route_to_nat" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  route_table_id         = aws_route_table.private_route_table.id
}