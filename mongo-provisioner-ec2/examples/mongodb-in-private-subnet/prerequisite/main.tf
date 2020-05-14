provider "aws" {
  region = "us-east-1"
}

resource "aws_ebs_volume" "mongo-data-vol" {
  availability_zone = var.availability_zone
  type              = "gp2"
  size              = var.volume_size

  tags = {
    Name        = "mongo-data-ebs-volume"
    Environment = var.environment_tag
  }
}

resource "aws_instance" "my_bastion_host" {
  ami                         = var.bastion_host_ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  # the VPC subnet
  subnet_id = aws_subnet.my_public_subnet_1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  tags = {
    Name = "my_bastion_host"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mybastionkeypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}
