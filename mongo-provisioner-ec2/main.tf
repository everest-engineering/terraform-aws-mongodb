data "aws_ami" "ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
      var.ami_filter_name]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  filter {
    name = "root-device-type"
    values = [
      "ebs"]
  }
  owners = [
    "099720109477"]
  # Canonical
}

resource "aws_security_group" "sg_mongodb" {
  name   = "sg_mongodb"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "MongoDB access"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name = var.environment_tag
    Environment = var.environment_tag
  }
}

resource "aws_key_pair" "mongo_keypair" {
  key_name   = "mongo-publicKey"
  public_key = var.public_key
}

resource "aws_instance" "mongo_server" {
  ami                    = var.ami_id == "" ? data.aws_ami.ami.id : var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg_mongodb.id]
  key_name               = aws_key_pair.mongo_keypair.key_name
  availability_zone      = var.availability_zone

  tags = {
    Name = var.environment_tag
    Environment = var.environment_tag
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
  }

  provisioner "file" {
    source      = "${path.module}/provisioning/wait-for-cloud-init.sh"
    destination = "/tmp/wait-for-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
      "chmod +x /tmp/wait-for-cloud-init.sh",
      "/tmp/wait-for-cloud-init.sh",
    ]
  }
}

resource "aws_volume_attachment" "mongo-data-vol-attachment" {
  device_name = "/dev/xvdh"
  volume_id = var.ebs_volume_id
  instance_id = aws_instance.mongo_server.id

  skip_destroy = true

  connection {
    host        = aws_instance.mongo_server.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
  }

  provisioner "file" {
    source      = "${path.module}/provisioning/mount-data-volume.sh"
    destination = "/tmp/mount-data-volume.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mount-data-volume.sh",
      "/tmp/mount-data-volume.sh",
    ]
  }

  provisioner "ansible" {
    plays {
      playbook {
        file_path = "${path.module}/provisioning/playbook.yaml"
      }
      extra_vars = {
        mongodb_version = var.mongodb_version
      }
      groups = ["db-mongodb"]
    }
  }
}