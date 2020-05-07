resource "aws_subnet" "main-subnet-public-1" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "main-subnet-public-1"
    }
}

resource "aws_internet_gateway" "main-igw" {
    vpc_id =aws_vpc.main-vpc.id
    tags = {
        Name = "main-igw"
    }
}

resource "aws_route_table" "main-public-crt" {
    vpc_id = aws_vpc.main-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.main-igw.id
    }
    
    tags =  {
        Name = "main-public-crt"
    }
}

resource "aws_route_table_association" "main-crta-public-subnet-1"{
    subnet_id = aws_subnet.main-subnet-public-1.id
    route_table_id = aws_route_table.main-public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.main-vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
      	cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh-db-allowed"
    }
}